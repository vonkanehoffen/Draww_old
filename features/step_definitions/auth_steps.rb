Given /^I am logged in$/ do
  @current_user = FactoryGirl.create(:user, {:username => "Herbert"})
  step 'I am logged in as "Herbert" with password "cormorant"'
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do | username, password |
  unless username.blank? || password.blank?
    visit new_user_session_path
    fill_in "user_session_username", :with => username
    fill_in "user_session_password", :with => password
    click_button "Login"
  end
end