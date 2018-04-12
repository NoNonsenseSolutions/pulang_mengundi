$(document).on('click', '.switch-items', function(){
  var self = $(this);
  $(".switch-items").removeClass('active');
  self.addClass('active');
})

document.addEventListener('turbolinks:load', function(){
  if($(".requests.index, .static_pages.home").length > 0){
    var total = parseInt($("#number-voter-request").data('total'))
    var numAnim = new countUp("number-voter-request", 0, total);
    numAnim.start()

    var total = parseInt($("#total-amount-pledged").data('total'))
    var numAnim2 = new countUp("total-amount-pledged", 0, total);
    numAnim2.start()
  }
})