ready = ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

$(document).ready(ready)
$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:update', ready)

App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'
  ,

  received: (data) ->
    $(".questions-list ul").append ("<li>#{data}</li>")
})
