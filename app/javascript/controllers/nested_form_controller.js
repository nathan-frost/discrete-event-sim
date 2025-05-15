import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nested-form"
export default class extends Controller {
  static targets = ["template", "field"]
  static values = {
    wrapperSelector: String
  }

  add() {
    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
    const wrapper = document.querySelector(this.wrapperSelectorValue)
    wrapper.insertAdjacentHTML("beforeend", content)
  }
  remove(event) {
      event.preventDefault()
      const field = event.target.closest(".resource-fields")
      const destroyInput = field.querySelector("input.destroy-flag")
      const visibleFields = this.fieldTargets.filter(element => element.style.display !== "none")

      if (visibleFields.length > 1) {
        destroyInput.value = "1"
        field.style.display = "none"
      } else {
        alert("At least one resource is required.")
      }
  }
}
