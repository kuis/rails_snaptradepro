require 'spec_helper'

describe 'user authentication' do
  let!(:user) { create(:user) }

  it 'allows signin with valid credentials' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    expect(page).to have_content('Signed in successfully')
  end

  it 'does not allow signin with invalid credentials' do
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: "wrong password"
    click_button 'Sign in'

    expect(page).to have_content('Invalid email or password')
  end

  it 'does not allow signin for deactivated user' do
    visit new_user_session_path
    user.active = false
    user.save

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    expect(page).to have_content("Your login attempt has failed.")
  end

  it 'allows user to sign out' do
    create(:user, :logged_in)
    visit root_path

    visit "users/sign_out"
    expect(page).to have_content('Signed out successfully')
  end
end
