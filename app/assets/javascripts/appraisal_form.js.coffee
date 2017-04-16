$ ->

  $(document).on "change", "input[type=filepicker]", (event) ->
    file = event.originalEvent.fpfile
    $image = $(this).closest(".image-field").find("img")
    $image.attr("src", file.url)

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


