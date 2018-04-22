function updateConstituencyList() {
  var stateSelect = $('#request_to_state'),
    selectedState = stateSelect.val(),
    constituencySelect = $('#request_to_city');
  if(selectedState){
    var constituencyList = $('[data-constituency-list]').data('constituency-list')
    var currentConstituencyList = constituencyList[selectedState]
    constituencySelect.children('option').remove()
    $.each(currentConstituencyList, function(index, value){
      constituencySelect
        .append(
          $('<option></option>')
            .attr('value', value)
            .text(value)
        );
    })
  } else {
    constituencySelect.children('option').remove()
  }

  if($('[data-admin]').data('admin') && $('[data-admin]').data('admin').val() !== undefined) {
    constituencySelect.selectpicker('refresh');
  }
}



$(document).on('change', '#request_to_state', function(){
  updateConstituencyList()
})

document.addEventListener("turbolinks:load", function(){
  if($('#request_to_state').length > 0){
    updateConstituencyList()
  }

  if($('.requests.new').length > 0){
    $('#one-request-modal').modal('show')
  }
})

$(document).on('change', '#custom-file-input', function(){
  $('#file-name-box').empty()
  $.each(this.files, function(i, val){
    var label = $("<span>", {"class": "label label-info"}).text(val.name)
    $("#file-name-box").append(label)
  })
})
