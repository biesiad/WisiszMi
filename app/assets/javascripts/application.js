// FIXME: Tell people that this is a manifest file, real code should go into discrete files
// FIXME: Tell people how Sprockets and CoffeeScript works
//
//= require jquery
//= require jquery_ujs
//= require jquery.masonry.min.js
//= require_tree .

$(function() {
  $('.app_info_page').click(function(event) {
    top.location.href = 'http://www.facebook.com/apps/application.php?id=' + Facebook.APP_ID + '&sk=info';
    event.preventDefault();
  });
});
