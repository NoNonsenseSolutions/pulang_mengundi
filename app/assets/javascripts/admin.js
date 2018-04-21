//= require activestorage
//= require jquery
//= require jquery.turbolinks
//= require jquery.maskedinput.min
//= require rails-ujs
//= require bootstrap-sprockets
//= require bootstrap-select
//= require turbolinks
//= require turbolinks-compatibility
//= require abracadabra

document.addEventListener("turbolinks:load", function(){
  $('.selectpicker').selectpicker('render');
})

document.addEventListener("turbolinks:before-cache", function(){
  $('.selectpicker').selectpicker('destroy').addClass('selectpicker')
})

