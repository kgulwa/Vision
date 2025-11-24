import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["overlay", "newCollectionName"]

  open() {
    this.overlayTarget.classList.remove("hidden")
  }

  close() {
    this.overlayTarget.classList.add("hidden")
  }

  saveToExisting(event) {
    const collectionUid = event.currentTarget.dataset.collectionUid
    const pinUid = this.data.get("pinUid")

    this.post(`/pins/${pinUid}/saved_pins`, {
      collection_uid: collectionUid
    })
  }

  createCollection() {
    const name = this.newCollectionNameTarget.value.trim()
    const pinUid = this.data.get("pinUid")

    if (name.length === 0) return

    this.post(`/pins/${pinUid}/saved_pins`, {
      new_collection_name: name
    })
  }

  saveToDefault() {
    const pinUid = this.data.get("pinUid")

    this.post(`/pins/${pinUid}/saved_pins`, {})
  }

  post(url, data) {
    fetch(url, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(data)
    })
  }
}
