package domain

import "time"

type MedicineVariant struct {
	ID          uint      `gorm:"primaryKey"`
	MedicineID  uint      `gorm:"not null"`
	Name        string    `gorm:"not null"`
	Price       float64   `gorm:"not null"`
	Stock       int       `gorm:"not null"`
	Brand		string	  `gorm:"not null"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
}