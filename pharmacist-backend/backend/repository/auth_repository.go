package repository

import "pharmacist-backend/backend/domain"

type AuthRepository interface {
	FindByEmail(email string) (*domain.User, error)
}