package domain

import "time"

type User struct {
	ID         uint      `gorm:"primaryKey"`
	Username   string    `gorm:"unique;not null"`
	Email      string    `gorm:"unique;not null"`
	Password   string    `gorm:"not null"`
	Role       string    `gorm:"not null"` // pharmacist or admin
	PharmacyID uint      `gorm:"not null"`
	CreatedAt  time.Time
	UpdatedAt  time.Time
}