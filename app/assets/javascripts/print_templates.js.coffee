# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $(".sortable").sortable
    revert: true
    start: ( event, ui ) ->
      $(this).find(".text-danger").addClass("hide")
    stop: ( event, ui ) ->
      $(ui.item).find("#section_").val($(event.target).attr("id"))
      section = $(this).attr("id")
      if section == "left_section"
        limit = 8
      else if section == "right_section"
        limit = 2
      else
        limit = 30

      if $(this).children(".draggable").length > limit
        $(ui.item).remove()
        $(this).find(".text-danger").removeClass("hide")

  $("#table_block, #photo_block, .divider").draggable
    connectToSortable: ".sortable"
    revert: "invalid"
    helper: "clone"

  $(".sortable").on "click", ".draggable i.fa-times", ->
    $(this).parent().remove()

  $(".sortable").on "click", ".draggable a.show-property-modal", ->
    category_id = $(this).parent().parent().find("select").val()
    hidden_fields = $(this).parent().parent().find("#hidden_fields_").val().split(",")
    $("#category_property_modal #category_id").val(category_id)

    $.getJSON "/appraisal_categories/#{category_id}.json?", (result) ->
      $("#category_property_modal tbody tr:not(.template)").remove()

      $.each result, (index, e) ->
        element = $("#category_property_modal tbody tr.template").clone()
        element.find("input[type=checkbox]").val(e.id)

        # if field is not in hidden_fields list, do check
        if hidden_fields.indexOf("#{e.id}") < 0
          element.find("input[type=checkbox]").prop("checked", "checked")

        element.find("#name").text(e.name)
        element.find("#label").text(e.label)
        element.removeClass("template hide")
        $(".modal tbody").append(element)

      $('#category_property_modal').modal('show')

  $("#category_property_modal .btn-primary").on "click", ->
    category_id = $("#category_property_modal #category_id").val()
    unchecked_properties = $("#category_property_modal tr:not(.template) input:checkbox:not(:checked)")
    hidden_property_ids = []
    $.each unchecked_properties, (i, element) ->
      hidden_property_ids.push $(element).val()

    hidden_property_ids = hidden_property_ids.join(",")
    $.each $("select.category"), (i, element) ->
      if $(element).val() == category_id
        $(element).parent().find("#hidden_fields_").val(hidden_property_ids)

    $('#category_property_modal').modal('hide')

  $("#print_template_form").on 'submit', ->
    $('#clonable').remove()
