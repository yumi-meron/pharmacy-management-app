package domain

import "time"

type Medicine struct {
	ID          uint      `gorm:"primaryKey"`
	Title       string    `gorm:"not null"`
	Description string
	Usage       string
	Barcode     string    `gorm:"unique"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
}