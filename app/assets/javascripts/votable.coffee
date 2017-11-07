voting = ->
  $('.voting a').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)

    if response.type == 'Question'
      link = ".question"
    else if response.type == 'Answer'
      id = $(this).data('answerId')
      link = ".answers div#answer-id-#{id}"

    $("#{link} .score").html("<p>Likes: #{response.score}</p>")

    if response.status
      $("#{link} a.vote-link-true").hide()
      $("#{link} a.vote-link-false").show()
    else
      $("#{link} a.vote-link-true").show()
      $("#{link} a.vote-link-false").hide()

$(document).ready(voting)
