import "@hotwired/turbo";
import { Application } from "@hotwired/stimulus";

// Start Stimulus
const application = Application.start();
window.Stimulus = application; // So you can test in the console

// MANUAL controller loading (ESBuild does NOT support import.meta.glob)
import DropdownController from "./controllers/dropdown_controller";
import EmailValidationController from "./controllers/email_validation_controller";
import HelloController from "./controllers/hello_controller";
import LoginValidationController from "./controllers/login_validation_controller";
import MentionsController from "./controllers/mentions_controller";
import PasswordValidationController from "./controllers/password_validation_controller";
import SaveModalController from "./controllers/save_modal_controller";
import UsernameValidationController from "./controllers/username_validation_controller";

// Register controllers
application.register("dropdown", DropdownController);
application.register("email-validation", EmailValidationController);
application.register("hello", HelloController);
application.register("login-validation", LoginValidationController);
application.register("mentions", MentionsController);
application.register("password-validation", PasswordValidationController);
application.register("save-modal", SaveModalController);
application.register("username-validation", UsernameValidationController);
