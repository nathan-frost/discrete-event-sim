import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, interval: Number }

  connect() {
    console.log("✅ Output controller connected:", this.urlValue)
    this.timer = setInterval(() => this.refresh(), this.intervalValue || 3000)
  }

  disconnect() {
    clearInterval(this.timer)
  }

  refresh() {
    console.log("↻ Polling:", this.urlValue)
    fetch(this.urlValue, {
      headers: { Accept: "text/vnd.turbo-stream.html" }
    })
    .then(r => {
      console.log("📥 Response:", r.status)
      if (r.status === 204) {
        console.log("⏳ No content yet")
        return;
      }
      return r.text().then(html => {
        console.log("📄 Turbo Stream received:\n", html)
        Turbo.renderStreamMessage(html)
        clearInterval(this.timer) // ✅ Stop polling
      });
    })
    .catch(err => console.error("❌ Fetch error:", err));
  }
}
