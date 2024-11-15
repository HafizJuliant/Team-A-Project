package model

type Account struct {
	AccountID int64  `json:"account_id" gorm:"primaryKey;autoIncrement;<-:false"`
	Name      string `json:"name"`
	Balance   int64  `json:"balance"`
	Alamat 		string `json:"alamat"`
	No_telp int64 `json:"no_telp"`
	Bank_id string `json:"bank_id"`
}