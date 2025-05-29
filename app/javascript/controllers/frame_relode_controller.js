import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("🔁 Frame reloaded - chart should reinitialize")
    // Nothing to do here if your canvas has data-controller="chart"
    // Stimulus will reinitialize all children
  }
}
