package repository

import (
	"errors"
	"pharmacist-backend/backend/domain"
	"gorm.io/gorm"
)

type AuthRepositoryPostgres struct {
	DB *gorm.DB
}

func NewAuthRepositoryPostgres(db *gorm.DB) *AuthRepositoryPostgres {
	return &AuthRepositoryPostgres{DB: db}
}

func (r *AuthRepositoryPostgres) FindByEmail(email string) (*domain.User, error) {
	var user domain.User
	if err := r.DB.Where("email = ?", email).First(&user).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, errors.New("user not found")
		}
		return nil, err
	}
	return &user, nil
}