$(document).ready(function() {
  mixpanel.track_links('a#dropbox-signup-frontpage', "Starts dropbox link", {'Page': 'Frontpage'})
  mixpanel.track_forms('form#user_registers', "User registers")
  mixpanel.track_forms('form#new_user', "User sign-in")
});