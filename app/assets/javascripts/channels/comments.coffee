App.comments = App.cable.subscriptions.create "CommentsChannel",
  connected: ->
    console.log 'Comment connected'
    @perform 'follow', question_id: gon.question_id

  received: (data) ->
    comment = $.parseJSON(data)

    return if gon.current_user_id == comment.user_id

    type = comment.commentable_type.toLowerCase();
    id = comment.commentable_id
    form_path = "form##{type}-comment-form-#{id}"

    $(form_path).parent('.form').siblings('.list').append(JST["templates/comment"]({comment: comment}));
