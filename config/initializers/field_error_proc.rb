# Disable field_with_errors wrapper to prevent breaking Tailwind styling
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html_tag.html_safe
end