package repository

import (
	"errors"
	"pharmacist-backend/backend/domain"
	"gorm.io/gorm"
)

type MedicineRepositoryPostgres struct {
	DB *gorm.DB
}

func NewMedicineRepositoryPostgres(db *gorm.DB) *MedicineRepositoryPostgres {
	return &MedicineRepositoryPostgres{DB: db}
}

func (r *MedicineRepositoryPostgres) Search(query string) ([]domain.Medicine, error) {
	var medicines []domain.Medicine
	if err := r.DB.Where("title ILIKE ? OR barcode ILIKE ?", "%"+query+"%", "%"+query+"%").Find(&medicines).Error; err != nil {
		return nil, err
	}
	return medicines, nil
}

func (r *MedicineRepositoryPostgres) FindByID(id uint) (*domain.Medicine, []domain.MedicineVariant, error) {
	var medicine domain.Medicine
	if err := r.DB.First(&medicine, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil, errors.New("medicine not found")
		}
		return nil, nil, err
	}

	var variants []domain.MedicineVariant
	if err := r.DB.Where("medicine_id = ?", id).Find(&variants).Error; err != nil {
		return nil, nil, err
	}

	return &medicine, variants, nil
}