# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();


$(document).ready(ready)
$(document).on('turbolinks:load', ready)
$(document).on('turbolinks:update', ready)

voting = ->
  $('.question .voting a').bind 'ajax:success', (e, data, status, xhr) ->
    question = $.parseJSON(xhr.responseText)
    $(".question .score").html("<p>Likes: #{question.score}</p>")
    if question.status
      $(".question .voting a.vote-link-true").hide()
      $(".question .voting a.vote-link-false").show()
    else
      $(".question .voting a.vote-link-true").show()
      $(".question .voting a.vote-link-false").hide()

$(document).ready(voting)
