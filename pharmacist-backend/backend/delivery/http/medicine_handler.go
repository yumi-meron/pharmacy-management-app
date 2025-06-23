package http

import (
	"net/http"
	"pharmacist-backend/backend/usecase/medicine"
	"strconv"

	"github.com/gin-gonic/gin"
)

type MedicineHandler struct {
	Usecase *medicine.MedicineUsecase
}

func NewMedicineHandler(r *gin.RouterGroup, uc *medicine.MedicineUsecase) {
	handler := &MedicineHandler{Usecase: uc}
	r.GET("/search", handler.Search)
	r.GET("/:id", handler.GetDetails)
}

func (h *MedicineHandler) Search(c *gin.Context) {
	query := c.Query("query")
	medicines, err := h.Usecase.Search(query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{"medicines": medicines})
}

func (h *MedicineHandler) GetDetails(c *gin.Context) {
	idStr := c.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid ID"})
		return
	}

	medicine, variants, err := h.Usecase.GetDetails(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"medicine": medicine,
		"variants": variants,
	})
}