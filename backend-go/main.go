package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

type transfer struct {
	AccountID   string `json:"account_id"`
	Name string `json:"name"`
	Balance string `json:"balance"`
	BankID int64 `json:"bank_id"` 
}

type MyAPIResponse struct {
	Data []transfer `json:"data"`
}

func main() {
	http.HandleFunc("/transfer", MyAPIHandler)
	fmt.Println("Server starting on port 8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func MyAPIHandler(w http.ResponseWriter, r *http.Request) {
	// URL of the external API
	externalAPIURL := "http://147.139.143.164:8082/api/v1/transfer"

	// Make a GET request to the external API
	resp, err := http.Get(externalAPIURL)
	if err != nil {
		http.Error(w, "Failed to fetch data from external API", http.StatusInternalServerError)
		return
	}
	defer resp.Body.Close()

	// Read the response body
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		http.Error(w, "Failed to read response body", http.StatusInternalServerError)
		return
	}

	// Parse the external API response
	var DataTransfers []transfer
	err = json.Unmarshal(body, &DataTransfers)
	if err != nil {
		http.Error(w, "Failed to parse JSON response", http.StatusInternalServerError)
		return
	}

	// Create your own API response structure and populate it with the external data
	myResponse := MyAPIResponse{
		Data: DataTransfers,
	}

	// Set response headers and encode response as JSON
	w.Header().Set("Content-Type", "application/json")
	err = json.NewEncoder(w).Encode(myResponse)
	if err != nil {
		http.Error(w, "Failed to encode JSON response", http.StatusInternalServerError)
		return
	}
}
