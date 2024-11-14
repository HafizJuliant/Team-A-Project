package handler

import (
	"backend-go/model"
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type BankHandler struct {
	db *gorm.DB
}

type Bank struct {
	ID   string `json:"bank_id"`
	Name string `json:"name"`
}

type ExternalAPIResponse struct {
	Status  int         `json:"status"`
	Message string      `json:"message"`
	Data    interface{} `json:"data"`
}

type TransferRequest struct {
	BankID        string  `json:"bank_id"`
	AccountID string  `json:"account_id"`
	Amount        int64 `json:"amount"`
}

func NewBankHandler(db *gorm.DB) *BankHandler {
	return &BankHandler{db: db}
}

// ListBanks fetches banks from external API and adds Celengan bank
func (h *BankHandler) ListBanks(c *gin.Context) {
	// Fetch banks from external API
	externalBanks, err := h.fetchExternalBanks()
	if err != nil {
		c.JSON(500, gin.H{"error": "Failed to fetch bank list"})
		return
	}

	// Add Celengan bank
	celenganBank := Bank{
		ID:   "00-21",
		Name: "Bank Celengan",
	}

	banks := append([]Bank{celenganBank}, externalBanks...)
	c.JSON(200, banks)
}

// CheckTransferAccount validates account for transfer
func (h *BankHandler) CheckTransferAccount(c *gin.Context) {
	var req struct {
		BankID        string `json:"bank_id"`
		AccountNumber string `json:"account_number"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	// Check if it's internal (Celengan) bank
	if req.BankID == "00-21" {
		var account model.Account
		if err := h.db.Where("id = ?", req.AccountNumber).First(&account).Error; err != nil {
			c.JSON(404, gin.H{"error": "Account not found"})
			return
		}
		c.JSON(200, gin.H{
			"valid": true,
			"account_info": map[string]interface{}{
				"account_id": account.AccountID,
				"name":           account.Name,
			},
		})
		return
	}

	// Check external bank account
	valid, accountInfo, err := h.checkExternalAccount(req.BankID, req.AccountNumber)
	if err != nil {
		c.JSON(500, gin.H{"error": "Failed to check account"})
		return
	}

	c.JSON(200, gin.H{
		"valid":        valid,
		"account_info": accountInfo,
	})
}

// Transfer handles money transfer between accounts
func (h *BankHandler) Transfer(c *gin.Context) {
	var req TransferRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(400, gin.H{"error": err.Error()})
		return
	}

	// Get sender's account
	userID := c.GetUint("user_id")
	var senderAccount model.Account
	if err := h.db.First(&senderAccount, userID).Error; err != nil {
		c.JSON(404, gin.H{"error": "Sender account not found"})
		return
	}

	// Check sufficient balance
	if senderAccount.Balance < req.Amount {
		c.JSON(400, gin.H{"error": "Insufficient balance"})
		return
	}

	// Start transaction
	tx := h.db.Begin()

	// Update sender's balance
	if err := tx.Model(&senderAccount).Update("balance", senderAccount.Balance-req.Amount).Error; err != nil {
		tx.Rollback()
		c.JSON(500, gin.H{"error": "Failed to update sender's balance"})
		return
	}

	// If internal transfer (Celengan bank)
	if req.BankID == "00-21" {
		var recipientAccount model.Account
		if err := tx.First(&recipientAccount, req.AccountID).Error; err != nil {
			tx.Rollback()
			c.JSON(404, gin.H{"error": "Recipient account not found"})
			return
		}

		// Update recipient's balance
		if err := tx.Model(&recipientAccount).Update("balance", recipientAccount.Balance+req.Amount).Error; err != nil {
			tx.Rollback()
			c.JSON(500, gin.H{"error": "Failed to update recipient's balance"})
			return
		}
	} else {
		// External transfer
		if err := h.processExternalTransfer(req); err != nil {
			tx.Rollback()
			c.JSON(500, gin.H{"error": "Failed to process external transfer"})
			return
		}
	}

	// Create transaction record
	transaction := model.Transaction{
		AccountID:       senderAccount.AccountID,
		Amount:          req.Amount,
	}

	if err := tx.Create(&transaction).Error; err != nil {
		tx.Rollback()
		c.JSON(500, gin.H{"error": "Failed to create transaction record"})
		return
	}

	// Commit transaction
	tx.Commit()

	c.JSON(200, gin.H{
		"message":        "Transfer successful",
		"transaction_id": transaction.TransactionID,
	})
}

// Helper functions for external API calls
func (h *BankHandler) fetchExternalBanks() ([]Bank, error) {
	resp, err := http.Get(os.Getenv("EXTERNAL_API_URL") + "/banks")
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var apiResp ExternalAPIResponse
	if err := json.NewDecoder(resp.Body).Decode(&apiResp); err != nil {
		return nil, err
	}

	// Convert api response data to []Bank
	banksData, err := json.Marshal(apiResp.Data)
	if err != nil {
		return nil, err
	}

	var banks []Bank
	if err := json.Unmarshal(banksData, &banks); err != nil {
		return nil, err
	}

	return banks, nil
}

func (h *BankHandler) checkExternalAccount(bankID, accountNumber string) (bool, map[string]interface{}, error) {
	url := fmt.Sprintf("%s/banks/%s/accounts/%s", os.Getenv("EXTERNAL_API_URL"), bankID, accountNumber)
	resp, err := http.Get(url)
	if err != nil {
		return false, nil, err
	}
	defer resp.Body.Close()

	var apiResp ExternalAPIResponse
	if err := json.NewDecoder(resp.Body).Decode(&apiResp); err != nil {
		return false, nil, err
	}

	if apiResp.Status != 200 {
		return false, nil, nil
	}

	accountInfo, ok := apiResp.Data.(map[string]interface{})
	if !ok {
		return false, nil, fmt.Errorf("invalid account info format")
	}

	return true, accountInfo, nil
}

func (h *BankHandler) processExternalTransfer(req TransferRequest) error {
	transferData := map[string]interface{}{
		"bank_id":        req.BankID,
		"account_id": req.AccountID,
		"amount":         req.Amount,
	}

	jsonData, err := json.Marshal(transferData)
	if err != nil {
		return err
	}

	resp, err := http.Post(
		os.Getenv("EXTERNAL_API_URL")+"/transfer",
		"application/json",
		bytes.NewBuffer(jsonData),
	)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	var apiResp ExternalAPIResponse
	if err := json.NewDecoder(resp.Body).Decode(&apiResp); err != nil {
		return err
	}

	if apiResp.Status != 200 {
		return fmt.Errorf("external transfer failed: %s", apiResp.Message)
	}

	return nil
}