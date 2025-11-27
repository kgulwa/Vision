import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "dropdown"]

  connect() {
    console.log("🔥 MentionsController connected")
    this.hideDropdown()
  }

  search() {
    if (!this.hasInputTarget || !this.hasDropdownTarget) return

    const cursor = this.inputTarget.selectionStart
    const text = this.inputTarget.value

    const match = text.slice(0, cursor).match(/@(\w*)$/)

    if (!match) {
      this.hideDropdown()
      return
    }

    const query = match[1]
    if (query.length === 0) return this.hideDropdown()

    fetch(`/mentions?q=${encodeURIComponent(query)}`)
      .then(res => res.json())
      .then(users => this.showDropdown(users))
      .catch(() => this.hideDropdown())
  }

  showDropdown(users) {
    if (!this.hasDropdownTarget) return
    if (!users || users.length === 0) return this.hideDropdown()

    this.dropdownTarget.innerHTML = users.map(user => `
      <div 
        class="mention-item p-2 hover:bg-gray-100 cursor-pointer flex items-center"
        data-username="@${user.username}"
      >
        <img src="${user.avatar || '/default-avatar.png'}" 
             class="w-6 h-6 rounded-full mr-2" alt="${user.username}">
        <span class="text-sm">${user.username}</span>
      </div>
    `).join("")

    this.dropdownTarget.classList.remove("hidden")

    this.dropdownTarget.querySelectorAll(".mention-item")
      .forEach(item => item.addEventListener("click", e => this.selectMention(e)))
  }

  selectMention(event) {
    const username = event.currentTarget.dataset.username
    const cursor = this.inputTarget.selectionStart
    const text = this.inputTarget.value

    this.inputTarget.value = text.replace(/@\w*$/, username + " ")
    this.hideDropdown()
    this.inputTarget.focus()
  }

  hideDropdown() {
    this.dropdownTarget.innerHTML = ""
    this.dropdownTarget.classList.add("hidden")
  }
}
