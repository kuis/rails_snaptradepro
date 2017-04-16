$ ->
  $('.img-editable').on 'click', (e)->
    $(e.target).next().click()

  $('.file-avatar').on 'change', (input) ->
    evt = input.target
    if evt.files and evt.files[0]
      reader = new FileReader()
      reader.onload = (e) ->
        $(evt).prev().attr 'src', e.target.result
        return

      reader.readAsDataURL evt.files[0]

  $('a.resend-invitation').bind 'ajax:success', (evt, data, status, xhr) ->
    if data.invitation_sent == false
      $("#invitation_pending").modal('show')
    else
      $(this).parent().parent().find('td.invitation-status').html("<span class='label label-primary'>Sent</span>")
      alert('Sent invitation successfully.')

  $('a.reset-password').bind 'ajax:success', (evt, data, status, xhr) ->
      alert('A password reset has been emailed to this Member')

  $('#members-list').on 'change', "input[type='checkbox'], select", ->
    $('#members-list .alert').removeClass('hide')
