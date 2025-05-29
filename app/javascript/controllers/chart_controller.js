import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    labels: Array,
    data: Array,
    label: String
  }

  connect() {
    const ctx = this.element.getContext("2d")

    new Chart(ctx, {
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: this.labelValue || "Dataset",
          data: this.dataValue,
          borderColor: "rgba(75, 192, 192, 1)",
          borderWidth: 2,
          tension: 0.3
        }]
      },
      options: {
        responsive: true
      }
    })
  }
}
