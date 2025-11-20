import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Debug mode so we see logs if something is wrong
application.debug = true

window.Stimulus = application

export { application }
