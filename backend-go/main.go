package main

import (
	"backend-go/handler"
	"backend-go/middleware"
	"log"
	"net/http"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/rs/cors"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type transfer struct {
	AccountID string `json:"account_id"`
	Name      string `json:"name"`
	Balance   string `json:"balance"`
	BankID    int64  `json:"bank_id"`
}

type MyAPIResponse struct {
	Data []transfer `json:"data"`
}

func main() {
	// Env
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading .env file", err)
	}

	// Database
	db := NewDatabase()
	sqlDB, err := db.DB()
	if err != nil {
		log.Fatal("failed to get DB from GORM:", err)
	}
	defer sqlDB.Close()

	// secret-key
	signingKey := os.Getenv("SIGNING_KEY")

	r := gin.Default()

	// grouping route with /auth
	authHandler := handler.NewAuth(db, []byte(signingKey))
	authRoute := r.Group("/auth")
	authRoute.POST("/login", authHandler.Login)
	authRoute.POST("/upsert", authHandler.Upsert)
	authRoute.POST("/change-password", middleware.AuthMiddleware(signingKey), authHandler.ChangePassword)

	// grouping route with /account
	accountHandler := handler.NewAccount(db)
	accountRoutes := r.Group("/account")
	accountRoutes.POST("/create", accountHandler.Create)
	accountRoutes.GET("/read/:id", accountHandler.Read)
	accountRoutes.PATCH("/update/:id", accountHandler.Update)
	accountRoutes.DELETE("/delete/:id", accountHandler.Delete)
	accountRoutes.GET("/list", accountHandler.List)
	accountRoutes.POST("/topup", accountHandler.TopUp)

	// middleware := middleware.AuthMiddleware(signingKey)
	accountRoutes.GET("/my", middleware.AuthMiddleware(signingKey), accountHandler.My)
	accountRoutes.GET("/balance", middleware.AuthMiddleware(signingKey), accountHandler.Balance)
	accountRoutes.POST("/transfer", middleware.AuthMiddleware(signingKey), accountHandler.TransferLocal)

	// grouping route with /transaction-category
	transaction_categoryHandler := handler.NewTransCat(db)
	transaction_categoryRoutes := r.Group("/transaction-category")
	transaction_categoryRoutes.POST("/create", transaction_categoryHandler.Create)
	transaction_categoryRoutes.GET("/read/:id", transaction_categoryHandler.Read)
	transaction_categoryRoutes.PATCH("/update/:id", transaction_categoryHandler.Update)
	transaction_categoryRoutes.DELETE("/delete/:id", transaction_categoryHandler.Delete)
	transaction_categoryRoutes.GET("/list", transaction_categoryHandler.List)

	transaction_categoryRoutes.GET("/my", middleware.AuthMiddleware(signingKey), transaction_categoryHandler.My)

	transactionHandler := handler.NewTrans(db)
	transactionRoutes := r.Group("/transaction")
	transactionRoutes.POST("/new", transactionHandler.NewTransaction)
	transactionRoutes.GET("/list", transactionHandler.TransactionList)

	bankHandler := handler.NewBankHandler(db)
	bankRoutes := r.Group("/bank")
	bankRoutes.POST("/transfer", bankHandler.Transfer)
	bankRoutes.GET("/list", bankHandler.ListBanks)

	c := cors.New(cors.Options{
		AllowedOrigins:   []string{"http://localhost:3000"},
		AllowedMethods:   []string{"GET", "POST", "PUT", "DELETE"},
		AllowedHeaders:   []string{"Authorization", "Content-Type", "Access-Control-Allow-Origin"},
		AllowCredentials: true,
	})

	handler := c.Handler(r)
	http.ListenAndServe(":8080", handler)

	r.Run(":8080") // listen and serve on 0.0.0.0:8080 (for windows "localhost:8080")
}

func NewDatabase() *gorm.DB {
	// dsn := "host=localhost port=5432 user=postgres dbname=digi sslmode=disable TimeZone=Asia/Jakarta"
	dsn := os.Getenv("DATABASE")
	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}

	sqlDB, err := db.DB()
	if err != nil {
		log.Fatalf("failed to get DB object: %v", err)
	}

	var currentDB string
	err = sqlDB.QueryRow("SELECT current_database()").Scan(&currentDB)
	if err != nil {
		log.Fatalf("failed to query current database: %v", err)
	}

	log.Printf("Current Database: %s\n", currentDB)

	return db
}
