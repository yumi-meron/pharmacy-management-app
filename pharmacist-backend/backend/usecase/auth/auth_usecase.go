package auth

import (
	"errors"
	"pharmacist-backend/backend/domain"
	"time"

	"github.com/dgrijalva/jwt-go"
	"golang.org/x/crypto/bcrypt"
)

type AuthUsecase struct {
	Repo      AuthRepository
	JWTSecret string
}

type AuthRepository interface {
	FindByEmail(email string) (*domain.User, error)
}

func NewAuthUsecase(repo AuthRepository, jwtSecret string) *AuthUsecase {
	return &AuthUsecase{Repo: repo, JWTSecret: jwtSecret}
}

func (uc *AuthUsecase) SignIn(email, password string) (string, *domain.User, error) {
	user, err := uc.Repo.FindByEmail(email)
	if err != nil {
		return "", nil, err
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", nil, errors.New("invalid credentials")
	}

	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": user.ID,
		"role":    user.Role,
		"exp":     time.Now().Add(time.Hour * 24).Unix(),
	})

	tokenString, err := token.SignedString([]byte(uc.JWTSecret))
	if err != nil {
		return "", nil, err
	}

	return tokenString, user, nil
}

func (uc *AuthUsecase) ForgotPassword(email string) error {
	_, err := uc.Repo.FindByEmail(email)
	if err != nil {
		return err
	}
	// Mock sending email (implement actual email service later)
	return nil
}