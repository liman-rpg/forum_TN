# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.answer').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault();
    answer_id = $(this).data('answerId')
    $(this).hide();
    $('form#edit-answer-' + answer_id).show()

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:update', ready)
