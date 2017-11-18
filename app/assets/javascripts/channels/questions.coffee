App.questions = App.cable.subscriptions.create "QuestionsChannel",
  connected: ->
    @perform 'follow'

  received: (data) ->
    $(".questions-list ul").append ("<li>#{data}</li>")
