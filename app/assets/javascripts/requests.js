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



function updateDistrictList() {
  var stateSelect = $('#request_from_state'),
    selectedState = stateSelect.val(),
    districtSelect = $('#request_from_city');
  if(selectedState){
    var districtList = $('[data-district-list]').data('district-list')
    var currentDistrictList = districtList[selectedState]
    districtSelect.children('option').remove()
    $.each(currentDistrictList, function(index, value){
      districtSelect
        .append(
          $('<option></option>')
            .attr('value', value)
            .text(value)
        );
    })
  } else {
    districtSelect.children('option').remove()
  }
}

function toggleFromDetails() {
  if($('#request_from_country').val() === 'Others') {
    $('#from-state-city').hide()
    $('#from-details').show()
  } else {
    $('#from-state-city').show()
    $('#from-details').hide()
  }
}


$(document).on('change', '#request_from_state', function(){
  updateDistrictList()
})

$(document).on('change', '#request_to_state', function(){
  updateConstituencyList()
})

$(document).on('change', '#request_from_country', function(){
  toggleFromDetails()
})

document.addEventListener("turbolinks:load", function(){
  if($('#request_to_state').length > 0){
    updateConstituencyList()
  }

  if($('#request_from_state').length > 0){
    updateDistrictList()
  }

  if($('#request_from_details').length > 0){
    toggleFromDetails()
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
