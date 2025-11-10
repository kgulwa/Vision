import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["password", "confirmation", "passwordError", "confirmationError"]

  validatePassword() {
    const password = this.passwordTarget.value
    
    if (password === "") {
      this.hideError(this.passwordErrorTarget, this.passwordTarget)
      return
    }

    if (password.length < 6) {
      this.showError(this.passwordErrorTarget, this.passwordTarget, "Password is too short (minimum is 6 characters)")
    } else {
      this.hideError(this.passwordErrorTarget, this.passwordTarget)
    }

    // Also check confirmation if it has a value
    if (this.confirmationTarget.value !== "") {
      this.validateConfirmation()
    }
  }

  validateConfirmation() {
    const password = this.passwordTarget.value
    const confirmation = this.confirmationTarget.value
    
    if (confirmation === "") {
      this.hideError(this.confirmationErrorTarget, this.confirmationTarget)
      return
    }

    if (password !== confirmation) {
      this.showError(this.confirmationErrorTarget, this.confirmationTarget, "Password confirmation doesn't match")
    } else {
      this.hideError(this.confirmationErrorTarget, this.confirmationTarget)
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