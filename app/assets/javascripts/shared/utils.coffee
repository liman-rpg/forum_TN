App = window.App = {}

App.utils =
  errorMessage: (message) ->
    return unless message
    console.warn(message)
    $(".alert").html("#{message}");

  ajaxErrorHandler: (e, data) ->
    message = 'Unknown error'
    if data.status == 401
      message = 'Sign in, please'
    else if data.status == 404
      message = 'Not found'
    else if data.status >= 400 && data.status < 500
      message = data.responseText

    App.utils.errorMessage message

$ ->
  $(document).on 'ajax:error', App.utils.ajaxErrorHandler
