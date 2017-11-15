ready = ->
  $('.question').on 'click', '#voting-form', (e) ->
    e.preventDefault();
    $(this).hide();
    $('.new_comment').show();

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:update', ready)
