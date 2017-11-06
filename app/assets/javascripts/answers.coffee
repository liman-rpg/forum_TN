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

voting = ->
  $('.answers .voting a').bind 'ajax:success', (e, data, status, xhr) ->
    answer = $.parseJSON(xhr.responseText)
    id = $(this).data('answerId')
    $(".answers div#answer-id-#{id} .score").html("<p>Likes: #{answer.score}</p>")
    if answer.status
      $(".answers div#answer-id-#{id} a.vote-link-true").hide()
      $(".answers div#answer-id-#{id} a.vote-link-false").show()
    else
      $(".answers div#answer-id-#{id} a.vote-link-true").show()
      $(".answers div#answer-id-#{id} a.vote-link-false").hide()

$(document).ready(voting)
