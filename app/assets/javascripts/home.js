$(document).on('click', '.switch-items', function(){
  var self = $(this);
  $(".switch-items").removeClass('active');
  self.addClass('active');
})

document.addEventListener('turbolinks:load', function(){
  if($(".requests.index").length > 0){
    var total = parseInt($("#number-voter-request").data('total'))
    var numAnim = new countUp("number-voter-request", 0, total);
    numAnim.start()

    var total = parseInt($("#total-amount-pledgedt").data('total'))
    var numAnim = new countUp("total-amount-pledgedt", 0, total);
    numAnim.start()
  }
})