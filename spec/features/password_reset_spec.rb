require 'spec_helper'

describe 'password reset' do
  let!(:user) { create(:user) }

  it 'allows user to reset their password' do
    visit new_user_session_path
    click_link "Forgot"
    fill_in 'Email', with: user.email
    click_button 'reset password'

    expect(page).to have_content(" You will receive an email with instructions on how to reset your password")

    open_email(user.email)
    visit_in_email 'Change my password'

    fill_in 'New password', with: 'my new PW'
    fill_in 'Confirm', with: 'my new PW'
    click_button 'Change my password'

    # user automatically signed in
    visit "users/sign_out"

    # try new password
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: "my new PW"
    click_button 'Sign in'

    expect(page).to have_content('Signed in successfully')
  end
end
