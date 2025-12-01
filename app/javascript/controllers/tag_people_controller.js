console.log("🔥 tag_people_controller.js LOADED")


import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["search", "results", "selected", "hiddenFields"]

  connect() {
    console.log("TagPeopleController connected!")
    this.selectedUsers = [] // store selected users { id, username, avatar }
  }

  // 🔍 Search users as you type
  async search() {
    const query = this.searchTarget.value.trim()

    if (query.length === 0) {
      this.resultsTarget.innerHTML = ""
      this.resultsTarget.classList.add("hidden")
      return
    }

    const response = await fetch(`/mentions?q=${encodeURIComponent(query)}`)
    const users = await response.json()

    if (users.length === 0) {
      this.resultsTarget.innerHTML = ""
      this.resultsTarget.classList.add("hidden")
      return
    }

    // Render results
    this.resultsTarget.innerHTML = users
      .filter(u => !this.selectedUsers.find(s => s.id === u.id))
      .map(
        user => `
        <div 
          class="p-2 hover:bg-gray-100 cursor-pointer flex items-center"
          data-action="click->tag-people#selectUser"
          data-user-info='${JSON.stringify(user)}'
        >
          <img src="${user.avatar || '/default-avatar.png'}"
               class="w-6 h-6 rounded-full mr-2">
          <span>${user.username}</span>
        </div>
      `
      )
      .join("")

    this.resultsTarget.classList.remove("hidden")
  }

  // ➕ Add user to selected list
  selectUser(event) {
    const user = JSON.parse(event.currentTarget.dataset.userInfo)

    // Add to internal list
    this.selectedUsers.push(user)

    // Update UI
    this.renderSelectedUsers()

    // Create hidden input so Rails receives user.id
    this.renderHiddenFields()

    // Hide dropdown and clear search box
    this.resultsTarget.classList.add("hidden")
    this.searchTarget.value = ""
  }

  //  Remove selected tag
  removeUser(event) {
    const userId = event.currentTarget.dataset.userid

    this.selectedUsers = this.selectedUsers.filter(u => u.id !== userId)

    this.renderSelectedUsers()
    this.renderHiddenFields()
  }

  
  renderSelectedUsers() {
    this.selectedTarget.innerHTML = this.selectedUsers
      .map(
        user => `
      <div class="flex items-center bg-gray-200 rounded-full px-3 py-1">
        <img src="${user.avatar || '/default-avatar.png'}"
             class="w-5 h-5 rounded-full mr-2">
        <span>${user.username}</span>
        <button 
          type="button" 
          class="ml-2 text-red-600"
          data-action="click->tag-people#removeUser"
          data-userid="${user.id}"
        >
          &times;
        </button>
      </div>
    `
      )
      .join("")
  }

  
  renderHiddenFields() {
    this.hiddenFieldsTarget.innerHTML = this.selectedUsers
      .map(
        user =>
          `<input type="hidden" name="pin[tagged_user_ids][]" value="${user.id}">`
      )
      .join("")
  }
}
