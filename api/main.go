package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"math/rand"
	"net/http"
	"os"
	"time"
)

// Handler for the /status route
func statusHandler(w http.ResponseWriter, r *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte("200 OK"))
}

// Handler for the /issues route
func issuesHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	// Read the JSON request body
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Generate a unique ID for the issue
	id := generateUniqueID()

	// Write the JSON data to a file with the ID as the filename
	err = os.WriteFile(fmt.Sprintf("bug-reports/%s.json", id), body, 0644)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}

	// Return the ID of the created issue as a response
	response := map[string]string{"id": id}
	responseData, _ := json.Marshal(response)

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusCreated)
	w.Write(responseData)
}

// Generate a unique ID for the issue
func generateUniqueID() string {
	rand.Seed(time.Now().UnixNano())
	return fmt.Sprintf("%d", rand.Intn(1000000))
}

func main() {
	http.HandleFunc("/status", statusHandler)
	http.HandleFunc("/issues", issuesHandler)

	fmt.Println("Server is running on port 8080")
	log.Fatal(http.ListenAndServe("0.0.0.0:8080", nil))
}
