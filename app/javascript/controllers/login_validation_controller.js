import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["username", "password", "usernameError", "passwordError", "submitButton"]

  connect() {
    this.timeout = null
  }

  validateUsername() {
    clearTimeout(this.timeout)
    
    const username = this.usernameTarget.value.trim()
    
    if (username === "") {
      this.hideError(this.usernameErrorTarget, this.usernameTarget)
      return
    }

    // Check if username exists after a delay (debounce)
    this.timeout = setTimeout(() => {
      this.checkUsernameExists(username)
    }, 500)
  }

  async checkUsernameExists(username) {
    try {
      const response = await fetch(`/users/check_username_exists?username=${encodeURIComponent(username)}`)
      const data = await response.json()
      
      if (data.exists) {
        this.hideError(this.usernameErrorTarget, this.usernameTarget)
      } else {
        this.showError(this.usernameErrorTarget, this.usernameTarget, "Username not found")
      }
    } catch (error) {
      console.error("Error checking username:", error)
    }
  }

  async validatePassword() {
    const username = this.usernameTarget.value.trim()
    const password = this.passwordTarget.value
    
    if (password === "" || username === "") {
      this.hideError(this.passwordErrorTarget, this.passwordTarget)
      return
    }

    // Check if password is correct
    try {
      const response = await fetch('/users/check_password', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ username: username, password: password })
      })
      
      const data = await response.json()
      
      if (data.valid) {
        this.hideError(this.passwordErrorTarget, this.passwordTarget)
      } else {
        this.showError(this.passwordErrorTarget, this.passwordTarget, "Password is incorrect")
      }
    } catch (error) {
      console.error("Error checking password:", error)
    }
  }

  showError(errorTarget, inputTarget, message) {
    errorTarget.textContent = message
    errorTarget.classList.remove("hidden")
    inputTarget.classList.add("border-red-500")
    inputTarget.classList.remove("border-gray-300")
  }

  hideError(errorTarget, inputTarget) {
    errorTarget.classList.add("hidden")
    inputTarget.classList.remove("border-red-500")
    inputTarget.classList.add("border-gray-300")
  }
}