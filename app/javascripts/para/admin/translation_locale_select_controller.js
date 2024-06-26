import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  static values = { pathTemplate: String };

  connect() {
    this.localeSelect = new TomSelect(this.element);
  }

  disconnect() {
    this.localeSelect.destroy();
  }

  switchLocale() {
    const url = this.pathTemplateValue.replace("__locale__", this.element.value);
    
    Turbo.visit(url);
  }
}
