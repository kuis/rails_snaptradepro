$ ->
  $("[data-behavior~=pinnable]").on "click", (e) ->
    appraisal_id    = $("#appraisal-id").val()
    organization_id = $("#organization-id").val()
    category_id     = $(this).closest(".jarviswidget").find(".category-id").val()

    $(this).toggleClass("pinned")

    if !$(this).hasClass("pinned")
      $.post("/organizations/#{organization_id}/appraisals/#{appraisal_id}/unpin", { category_id: category_id })

      if $("#valuations").length > 0
        $(this).parent().parent().fadeOut()
    else
      $.post("/organizations/#{organization_id}/appraisals/#{appraisal_id}/pin", { category_id: category_id })
