require 'snozcumber'

Scenario "I should have fun at the zoo" do
  Given a_monkey_called "dave"
  And a_donkey_called "alex", who_is: 29
  When i_visit_the_zoo
  Then i_should_have_fun_with "dave", and: "alex"
end

Scenario "Sign up with bad passwords" do
  Given i_fill_in "Email", with: "bob@gofreerange.com"
  And i_fill_in "Phone number", with: "07700900123"
  And i_fill_in "Password", with: ""
  And i_fill_in "Password confirmation", with: ""
  And i_press "Sign up"

  Then i_should_be_on_the_account_registration_page
  And i_should_be_warned_about "password", because_it: "should not be empty"

  And i_fill_in "Password", with: "something"
  And i_fill_in "Password confirmation", with: "different"
  And i_press "Sign up"

  Then i_should_be_on_the_account_registration_page
  And i_should_be_warned_about "password", because_it: "does not match confirmation"

  And i_fill_in "Password", with: "password"
  And i_fill_in "Password confirmation", with: "password"
  And i_press "Sign up"

  Then i_should_be_on_the_sms_confirmation_page
end