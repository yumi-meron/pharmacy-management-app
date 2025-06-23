package http

import (
	"net/http"
	"pharmacist-backend/backend/usecase/auth"

	"github.com/gin-gonic/gin"
)

type AuthHandler struct {
	Usecase *auth.AuthUsecase
}

func NewAuthHandler(r *gin.RouterGroup, uc *auth.AuthUsecase) {
	handler := &AuthHandler{Usecase: uc}
	r.POST("/signin", handler.SignIn)
	r.POST("/forgot-password", handler.ForgotPassword)
}

type SignInRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

func (h *AuthHandler) SignIn(c *gin.Context) {
	var req SignInRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	token, user, err := h.Usecase.SignIn(req.Email, req.Password)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"token": token,
		"user": gin.H{
			"id":          user.ID,
			"username":    user.Username,
			"role":        user.Role,
			"pharmacy_id": user.PharmacyID,
		},
	})
}

type ForgotPasswordRequest struct {
	Email string `json:"email" binding:"required,email"`
}

func (h *AuthHandler) ForgotPassword(c *gin.Context) {
	var req ForgotPasswordRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if err := h.Usecase.ForgotPassword(req.Email); err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Password reset email sent"})
}