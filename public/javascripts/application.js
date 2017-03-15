$('input:radio').click(function(e) {
  if ($(this).parents('.panel').children('.panel-collapse').hasClass('in')) {
    e.stopPropagation();
  }
});

$('#choose-album-accordion input:radio').click(function(e) {
  if ($(this).attr('data-target') === '#create-new') {
    $('#form-add-photo #btn-add-photo').hide();
    $('#form-add-photo #btn-create-album').show();
  } else {
    $('#form-add-photo #btn-add-photo').show();
    $('#form-add-photo #btn-create-album').hide();
  }
});
