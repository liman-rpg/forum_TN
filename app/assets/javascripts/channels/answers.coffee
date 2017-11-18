App.answers = App.cable.subscriptions.create "AnswersChannel",
  connected: ->
    console.log 'Connentcted'
    @perform 'follow', question_id: gon.question_id

  received: (data) ->
    answer = $.parseJSON(data)
    return if gon.current_user_id == answer.user_id

    $(".answers").append(JST["templates/answer"]({answer: answer}));
