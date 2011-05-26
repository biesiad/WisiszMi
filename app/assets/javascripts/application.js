// FIXME: Tell people that this is a manifest file, real code should go into discrete files
// FIXME: Tell people how Sprockets and CoffeeScript works
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(function() {
  FB.init({
    appId  : Facebook.APP_ID,
    status : true, // check login status
    cookie : true, // enable cookies to allow the server to access the session
    xfbml  : true  // parse XFBML
  });
  FB.Canvas.setAutoResize();

  $('.app_info_page').click(function(event) {
    top.location.href = 'http://www.facebook.com/apps/application.php?id=' + Facebook.APP_ID + '&sk=info';
    event.preventDefault();
  });
});
