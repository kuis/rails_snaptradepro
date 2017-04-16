$(document).ready () ->
  pageSetUp()

  if $(".colorpicker").length > 0
    $(".colorpicker").minicolors()

  $(".bootstrap-datepicker").datetimepicker pickTime: false
  $(".bootstrap-timepicker").datetimepicker()
  $('[data-toggle="popover"]').popover()

  $('textarea').keyup (e) ->
    rows = Math.max(3, $(this).val().split("\n").length)
    $(this).prop('rows', rows)
