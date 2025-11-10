import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error"]

  connect() {
    this.timeout = null
  }

  validate() {
    clearTimeout(this.timeout)
    
    const username = this.inputTarget.value.trim()
    
    if (username === "") {
      this.hideError()
      return
    }

    if (username.length < 3) {
      this.showError("Username is too short (minimum is 3 characters)")
      return
    }

    // Check for duplicate username after a delay (debounce)
    this.timeout = setTimeout(() => {
      this.checkUsernameAvailability(username)
    }, 500)
  }

  async checkUsernameAvailability(username) {
    try {
      const response = await fetch(`/users/check_username?username=${encodeURIComponent(username)}`)
      const data = await response.json()
      
      if (data.available) {
        this.hideError()
      } else {
        this.showError("Username has already been taken")
      }
    } catch (error) {
      console.error("Error checking username:", error)
    }
  }

  showError(message) {
    this.errorTarget.textContent = message
    this.errorTarget.classList.remove("hidden")
    this.inputTarget.classList.add("border-red-500")
    this.inputTarget.classList.remove("border-gray-300")
  }

  hideError() {
    this.errorTarget.classList.add("hidden")
    this.inputTarget.classList.remove("border-red-500")
    this.inputTarget.classList.add("border-gray-300")
  }
}