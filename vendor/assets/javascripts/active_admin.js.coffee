#= require active_admin/base
#= require plugin/datatables/jquery.dataTables.min
#= require plugin/datatables/dataTables.bootstrap.min
#= require jquery.minicolors.min
$ ->
  if $(".colorpicker").length > 0
    $(".colorpicker").minicolors()

  otable = $('table.datatable').dataTable(
    "autoWidth": true
    "aoColumnDefs": [
      "bSortable": false
      "aTargets": [0]
    ]
  )
