// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require countUp
//= require jquery
//= require bootstrap-sprockets
//= require bootstrap-select
//= require requests
//= require home


document.addEventListener("turbolinks:load", function(){
  $('.selectpicker').selectpicker('render');
})

document.addEventListener("turbolinks:before-cache", function(){
  $('.selectpicker').selectpicker('destroy').addClass('selectpicker')
})

document.addEventListener("turbolinks:load", function(event) {
  if (typeof ga === "function") {
    ga("set", "location", event.data.url);
    return ga("send", "pageview");
  }
});

(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = 'https://connect.facebook.net/en_GB/sdk.js#xfbml=1&version=v2.12&appId=2142897559273833&autoLogAppEvents=1';
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'pulangmengundi'));

(function($) {
  var fbRoot;

  function saveFacebookRoot() {
    if ($('#fb-root').length) {
      fbRoot = $('#fb-root').detach();
    }
  };

  function restoreFacebookRoot() {
    if (fbRoot != null) {
      if ($('#fb-root').length) {
        $('#fb-root').replaceWith(fbRoot);
      } else {
        $('body').append(fbRoot);
      }
    }

    if (typeof FB !== "undefined" && FB !== null) { // Instance of FacebookSDK
      FB.XFBML.parse();
    }
  };

  document.addEventListener('turbolinks:request-start', saveFacebookRoot)
  document.addEventListener('turbolinks:load', restoreFacebookRoot)
}(jQuery));


window.twttr = (function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0],
    t = window.twttr || {};
  if (d.getElementById(id)) return t;
  js = d.createElement(s);
  js.id = id;
  js.src = "https://platform.twitter.com/widgets.js";
  fjs.parentNode.insertBefore(js, fjs);

  t._e = [];
  t.ready = function(f) {
    t._e.push(f);
  };

  return t;
}(document, "script", "twitter-wjs"));


function renderTweetButtons() {
  $('.twitter-share-button').each(function() {
    var button;
    button = $(this);
    if (button.data('url') == null) {
      button.attr('data-url', document.location.href);
    }
    if (button.data('text') == null) {
      return button.attr('data-text', document.title);
    }
  });
  return twttr.widgets.load();
};

document.addEventListener('turbolinks:load', renderTweetButtons)