import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, interval: Number }

  connect() {
    // Delay the initial refresh by 10 seconds
    this.initialTimeout = setTimeout(() => {
      this.timer = setInterval(() => this.refresh(), this.intervalValue || 5000);
      this.refresh(); // Optionally call immediately after the delay
    }, 10000);
  }

  disconnect() {
    clearTimeout(this.initialTimeout);
    clearInterval(this.timer);
  }

  refresh() {
    fetch(this.urlValue, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })
    .then(r => {
      if (r.status === 204) return;
      return r.text().then(html => {
        Turbo.renderStreamMessage(html);
        clearInterval(this.timer);  // Stop polling once content arrives
      });
    });
  }
}
