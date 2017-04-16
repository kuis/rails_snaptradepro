$(document).ready ->

  form_Saved = false

  confirmExit = ->
    if form_Saved
      return 'Form Data has been modified.'
    return

  $('form.edit_valuation input').change ->
    form_Saved = true
    return

  window.onbeforeunload = confirmExit

  $('input[name=\'commit\']').click ->
    form_Saved = false
    return

  $('form.edit_valuation').submit ->
    form_Saved = false
    window.onbeforeunload = null
    return
  ###
  $(document.body).on "mouseenter", ".checklist-name", (e) ->
    $(".checklist-hover").hide()
    $(e.target).parent().find(".checklist-hover").show()

  $(document.body).on "mouseleave", ".checklist-name", (e) ->
    $(".checklist-hover").hide()
    $(e.target).parent().find(".checklist-hover").hide()
  ###

  $(".edit_valuation input").keypress (event) ->
    keyCode = if event.keyCode then event.keyCode else event.which
    if keyCode == '13'
      form_Saved = false
      $("form.edit_valuation").submit()
    return
  $(".numeric-field").each () ->
    options = {
      alias: "numeric"
      autoUnmask: true
      removeMaskOnSubmit: true
    }

    if $(this).data("comma-separated")
      options["groupSeparator"] = ","
      options["autoGroup"] = true

    if $(this).data("currency-symbol")
      options["prefix"] = "#{$(this).data("currency-symbol")} "

    if $(this).data("digits-after-decimal")
      options["digits"] = $(this).data("digits-after-decimal")
    $(this).inputmask options

    options = {
      alias: "numeric"
      autoUnmask: true,
      prefix: '$',
      groupSeparator : ',',
      autoGroup : true
      digits: 3
      removeMaskOnSubmit: true
    }
    $('#comment_price').removeClass('numeric')
    $('#comment_price').addClass('string')
    $('#comment_price').inputmask options