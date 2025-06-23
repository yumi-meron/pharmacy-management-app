package repository

import "pharmacist-backend/backend/domain"

type MedicineRepository interface {
	Search(query string) ([]domain.Medicine, error)
	FindByID(id uint) (*domain.Medicine, []domain.MedicineVariant, error)
}