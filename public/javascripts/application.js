$('input:radio').click(function(e) {
  if ($(this).parents('.panel').children('.panel-collapse').hasClass('in')) {
    e.stopPropagation();
  }
});

$('#choose-album-accordion input:radio').click(function() {
  if ($(this).attr('data-target') === '#create-new') {
    $('#form-add-photo #btn-add-photo').hide();
    $('#form-add-photo #btn-create-album').show();
  } else {
    $('#form-add-photo #btn-add-photo').show();
    $('#form-add-photo #btn-create-album').hide();
  }
});

$('#choose-existing').ready(function() {
  $(this).find('li').first().addClass('active');
  $(this).find('input:radio[name="album_id"]').first().prop('checked', true);
});

$('#choose-existing').on('click', 'li', function() {
  $(this).parents().children('li').removeClass('active');
  $(this).addClass('active');
  $(this).children('input:radio').prop('checked', true);
});
