$ ->
  categoryImages = []
  currentIndex = 0
  $imageModal = $("#image-modal")

  previewImage = (i) ->
    currentIndex = i
    image = categoryImages[i]

    if image.original.length > 0
      image_url = image.original
    else
      image_url = image.src

    $imageModal.find("img").attr("src", image_url)
    $imageModal.find("h4 span").text(image.label)

  imageIndexFromSrc = (src) ->
    index = null
    $.each categoryImages, (i, value) ->
      if value.src == src
        index = i
        return false
      true
    index

  setCategoryImages = (category) ->
    categoryImages = []
    category.find(".image-box").each () ->
      $img = $(this).find("img")
      src = $img.attr("src")
      label = $(this).text()
      original = $img.data("original-src")

      unless /placeholder/.test(src)
        categoryImages.push { src: src, label: label, original: original }

  $(document).on "click", "img.previewable", (e) ->
    e.preventDefault
    setCategoryImages($(this).closest(".category"))
    previewImage(imageIndexFromSrc($(this).attr("src")))
    $imageModal.modal("show")

  $(document).on "click", ".previous", (e) ->
    e.preventDefault

    if currentIndex - 1 < 0
      newIndex = categoryImages.length - 1
    else
      newIndex = currentIndex - 1

    previewImage(newIndex)

  $(document).on "click", ".next", (e) ->
    e.preventDefault

    if currentIndex + 1 == categoryImages.length
      newIndex = 0
    else
      newIndex = currentIndex + 1

    previewImage(newIndex)

  $(".clone-panel").on "click", (e) ->
    e.stopPropagation()


