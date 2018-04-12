$(document).on('click', '.switch-items', function(){
  var self = $(this);
  $(".switch-items").removeClass('active');
  self.addClass('active');
})