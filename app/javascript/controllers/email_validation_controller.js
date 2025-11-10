import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error"]
  static values = { url: String }

  connect() {
    this.timeout = null
  }

  validate() {
    clearTimeout(this.timeout)
    
    const email = this.inputTarget.value.trim()
    
    if (email === "") {
      this.hideError()
      return
    }

    // Basic email format validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email)) {
      this.showError("Email is invalid")
      return
    }

    // Check for duplicate email after a delay (debounce)
    this.timeout = setTimeout(() => {
      this.checkEmailAvailability(email)
    }, 500)
  }

  async checkEmailAvailability(email) {
    try {
      const response = await fetch(`/users/check_email?email=${encodeURIComponent(email)}`)
      const data = await response.json()
      
      if (data.available) {
        this.hideError()
      } else {
        this.showError("Email has already been taken")
      }
    } catch (error) {
      console.error("Error checking email:", error)
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