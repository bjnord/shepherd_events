function on_page_ready(ready_function) {
  // for full page load:
  $(document).ready(ready_function);
  // for Turbolinks partial page load:
  $(document).on('page:load', ready_function);
}
