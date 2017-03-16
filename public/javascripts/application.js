$('input:radio').click(function(e) {
  if ($(this).parents('.panel').children('.panel-collapse').hasClass('in')) {
    e.stopPropagation();
  }
});

$('#choose-album-accordion').ready(function() {
  if ($(this).find('input:radio[data-target="#create-new"]').is(':checked')) {
    $('#form-add-photo #btn-create-album').removeClass('hidden');
  } else {
    $('#form-add-photo #btn-add-photo').removeClass('hidden');
  }
});

$('#choose-album-accordion input:radio').click(function() {
  if ($(this).attr('data-target') === '#create-new') {
    $('#form-add-photo #btn-add-photo').addClass('hidden');
    $('#form-add-photo #btn-create-album').removeClass('hidden');
  } else {
    $('#form-add-photo #btn-add-photo').removeClass('hidden');
    $('#form-add-photo #btn-create-album').addClass('hidden');
  }
});

$('#choose-existing').ready(function() {
  if ($('li.active').length === 0) {
    var $first_album = $(this).find('li').first();
    $first_album.addClass('active');
    $first_album.find('input:radio[name="album_id"]').first().prop('checked', true);
  }
});

$('#choose-existing').on('click', 'li', function() {
  $(this).parents().children('li').removeClass('active');
  $(this).addClass('active');
  $(this).children('input:radio').prop('checked', true);
});

$('#form-edit-account').submit(function() {
  if ($('input[name="current_password"]').val() === "" && $('input[name="new_password"]').val() !== "") {
    $('#current-password').addClass('has-error');
    $('#current-password .help-block').removeClass('hidden');
    $('#new-password').removeClass('has-error');
    $('#new-password .help-block').addClass('hidden');
    return false;
  }

  if ($('input[name="current_password"]').val() !== "" && $('input[name="new_password"]').val() === "") {
    $('#current-password').removeClass('has-error');
    $('#current-password .help-block').addClass('hidden');
    $('#new-password').addClass('has-error');
    $('#new-password .help-block').removeClass('hidden');
    return false;
  }
});
