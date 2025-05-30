import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    labels: Array,
    data: Array,
    label: String
  }

  connect() {
    console.log("Chart controller connected");
    this.renderChart();
  }

  disconnect() {
    if (this.chartInstance) {
      this.chartInstance.destroy();
      this.chartInstance = null;
    }
  }

  renderChart() {
    const ctx = this.element.getContext("2d");

    this.chartInstance = new Chart(ctx, {
      type: "bar",
      data: {
        labels: this.labelsValue,
        datasets: [{
          label: this.labelValue || "Dataset",
          data: this.dataValue,
          backgroundColor: "rgba(75, 192, 192, 0.5)",
          borderColor: "rgba(75, 192, 192, 1)",
          borderWidth: 1
        }]
      },
      options: {
        responsive: true
      }
    });
  }
}
