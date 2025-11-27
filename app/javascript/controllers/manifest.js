import { application } from "./application"

import HelloController from "./hello_controller"
application.register("hello", HelloController)

import MentionsController from "./mentions_controller"
application.register("mentions", MentionsController)

import DropdownController from "./dropdown_controller"
application.register("dropdown", DropdownController)

import EmailValidationController from "./email_validation_controller"
application.register("email-validation", EmailValidationController)

import LoginValidationController from "./login_validation_controller"
application.register("login-validation", LoginValidationController)

import PasswordValidationController from "./password_validation_controller"
application.register("password-validation", PasswordValidationController)

import SaveModalController from "./save_modal_controller"
application.register("save-modal", SaveModalController)

import UsernameValidationController from "./username_validation_controller"
application.register("username-validation", UsernameValidationController)
