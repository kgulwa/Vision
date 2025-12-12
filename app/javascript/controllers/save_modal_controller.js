import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "newCollectionName"]
  static values = { pinUid: String }

  open() {
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
  }

  // Save to an existing collection using UID
  saveToExisting(event) {
    const collectionUid = event.currentTarget.dataset.collectionUid
    const pinUid = this.pinUidValue

    this.post(`/pins/${pinUid}/saved_pins`, {
      collection_uid: collectionUid
    })
  }

  // Create a new collection and save to it
  createCollection() {
    const name = this.newCollectionNameTarget.value.trim()
    if (name.length === 0) return

    const pinUid = this.pinUidValue

    this.post(`/pins/${pinUid}/saved_pins`, {
      new_collection_name: name
    })
  }

  // Save to default collection
  saveToDefault() {
    const pinUid = this.pinUidValue

    this.post(`/pins/${pinUid}/saved_pins`, {})
  }

  // Generic POST helper
  post(url, data) {
    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data)
    })
  }
}
