$ ->
  otable = $('#datatable_fixed_column').DataTable
    "bPaginate": false,
    "autoWidth": true
    "aoColumnDefs": [
      "bSortable": false
      "aTargets": [-1] # 1st one, start by the right
    ]
    #"bFilter": false,
    #"bInfo": false,
    #"bLengthChange": false
    #"bAutoWidth": false,
    #"bStateSave": true // saves sort state using localStorage

  $("#datatable_fixed_column thead th input[type=text]").on 'keydown', (event) ->
    if event.which == 13
      event.preventDefault()

  $("#datatable_fixed_column thead th input[type=text]").on 'keyup change onload', () ->
    otable.column( $(this).parent().index()+':visible' )
          .search( this.value )
          .draw()

  $("#datatable_fixed_column thead th select").on 'change', () ->
    if this.value == "any"
      otable.column($(this).parent().index()+':visible')
            .search("")
            .draw()
    else
      value = $(this).find("option:selected").text()
      otable.column($(this).parent().index()+':visible')
            .search("^#{value}$", true)
            .draw()
    $(".filtered-status").text($(this).find(":selected").text())
