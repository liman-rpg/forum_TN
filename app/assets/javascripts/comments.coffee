ready = ->
  $('body').on 'click', '.comment-form-link', (e) ->
    e.preventDefault();
    id = $(this).data('id')
    type = $(this).data('type')
    $(this).hide();
    $("##{type}-comment-form-#{id}").show();

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:update', ready)
