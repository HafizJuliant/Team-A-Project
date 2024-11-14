package model

import "time"

type Transaction struct {
	TransactionID         int64     `gorm:"primaryKey"`
	TransactionCategoryID *int64    `json:"transaction_category_id" gorm:"column:transaction_category_id"` // Nullable FK
	AccountID             int64     `json:"account_id" gorm:"not null"`
	FromAccountID         *int64    `json:"from_account_id" gorm:"column:from_account_id"`
	ToAccountID           *int64    `json:"to_account_id" gorm:"column:to_account_id"`
	Amount                int64     `json:"amount" gorm:"not null"`
	TransactionDesc		  string    `json:"transaction_desc" gorm:"transaction_desc"`
	TransactionDate       time.Time `json:"transaction_date"   gorm:"default:CURRENT_TIMESTAMP"`
	FromBankID			  int64		`json:"from_bank_id" gorm:"column:from_bank_id"`
	ToBankID			  int64		`json:"to_bank_id" gorm:"column:to_bank_id"`
}

func (Transaction) TableName() string {
	return "transaction"
}