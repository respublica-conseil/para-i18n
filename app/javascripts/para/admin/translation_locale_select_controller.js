import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

export default class extends Controller {
  connect() {
    this.localeSelect = new TomSelect(this.element);
  }

  disconnect() {
    this.localeSelect.destroy();
  }

  switchLocale() {
    const url = this.element.value;
    
    Turbo.visit(url);
  }
}
