$ ->
  $(document.body).on "mouseenter", ".checklist-item-container", (e) ->
    $(".checklist-item-hover").hide()
    $(e.target).parent().find(".checklist-item-hover").show()

  $(document.body).on "mouseleave", ".checklist-item-container", (e) ->
    $(".checklist-item-hover").hide()
    $(e.target).parent().find(".checklist-item-hover").hide()

  $(document.body).on "click", "[data-behavior~=check-list-item-completed]", (e) ->
    checklist_id      = $(e.target).data("check-list-id")
    checklist_item_id = $(e.target).data("check-list-item-id")

    $.post "/checklists/#{checklist_id}/checklist_items/#{checklist_item_id}/completed", ->
      $item = $(e.target).parent()
      $item.attr("data-behavior", "check-list-item-uncompleted")
      $item.parent().parent().parent().find(".completed-checklist-items").append($item.parent())

  $(document.body).on "click", "[data-behavior~=check-list-item-uncompleted]", (e) ->
    checklist_id      = $(e.target).data("check-list-id")
    checklist_item_id = $(e.target).data("check-list-item-id")

    $.post "/checklists/#{checklist_id}/checklist_items/#{checklist_item_id}/uncompleted", ->
      $item = $(e.target).parent()
      $item.attr("data-behavior", "check-list-item-completed")
      $item.parent().parent().parent().find(".checklist-item-add-btn").before($item.parent())
