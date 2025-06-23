package http

import (
	"pharmacist-backend/backend/config"
	"pharmacist-backend/backend/repository"
	"pharmacist-backend/backend/usecase/auth"
	"pharmacist-backend/backend/usecase/medicine"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupRoutes(router *gin.Engine, db *gorm.DB, cfg *config.Config) {
	api := router.Group("/api")

	// Repositories
	authRepo := repository.NewAuthRepositoryPostgres(db)
	medicineRepo := repository.NewMedicineRepositoryPostgres(db)

	// Use cases
	authUsecase := auth.NewAuthUsecase(authRepo, cfg.JWTSecret)
	medicineUsecase := medicine.NewMedicineUsecase(medicineRepo)

	// Handlers
	NewAuthHandler(api.Group("/auth"), authUsecase)
	NewMedicineHandler(api.Group("/medicines"), medicineUsecase)
}