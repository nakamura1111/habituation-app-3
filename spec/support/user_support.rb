module UserSupport
  def login_user(user)
    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    find('input[name="commit"]').click
    sleep(1)
    expect(current_path).to eq(root_path)
  end
end
