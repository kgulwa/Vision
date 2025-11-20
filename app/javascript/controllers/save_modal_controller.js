import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  open() {
    console.log("OPEN MODAL")
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.classList.add("flex")
  }

  close() {
    console.log("CLOSE MODAL")
    this.modalTarget.classList.add("hidden")
    this.modalTarget.classList.remove("flex")
  }
}
