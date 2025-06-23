package medicine

import "pharmacist-backend/backend/domain"

type MedicineUsecase struct {
	Repo MedicineRepository
}

type MedicineRepository interface {
	Search(query string) ([]domain.Medicine, error)
	FindByID(id uint) (*domain.Medicine, []domain.MedicineVariant, error)
}

func NewMedicineUsecase(repo MedicineRepository) *MedicineUsecase {
	return &MedicineUsecase{Repo: repo}
}

func (uc *MedicineUsecase) Search(query string) ([]domain.Medicine, error) {
	return uc.Repo.Search(query)
}

func (uc *MedicineUsecase) GetDetails(id uint) (*domain.Medicine, []domain.MedicineVariant, error) {
	return uc.Repo.FindByID(id)
}