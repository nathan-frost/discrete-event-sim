import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  reinitializeChart() {
    // Find the canvas element inside this frame
    const canvas = this.element.querySelector("[data-controller='chart']");
    if (!canvas) return;

    // Disconnect any existing chart controller
    const chartController = this.application.getControllerForElementAndIdentifier(canvas, "chart");
    if (chartController) {
      chartController.disconnect();
      chartController.connect();
    }
  }
}
