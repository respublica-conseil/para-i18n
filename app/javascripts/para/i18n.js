const application = window.Stimulus;

if (!application) {
    throw new Error(
      "Stimulus is not available in the global scope. Make sure to require Para and / " +
      "or initialize Stimulus in your application before loading this file."
    );
}

import TranslationLocaleSelectController from "./admin/translation_locale_select_controller";
application.register("translations-locale-select", TranslationLocaleSelectController);
