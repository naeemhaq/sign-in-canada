
@live
Feature: Create CATSLAB - GCKey Sign Up
    As a user
    I want to sign up to GCKey via CATSLAB

    Background:
        Given I open the url "https://rp1.tbstest.catslab.ca/RPSimulator/home-eng.jsp?_gc_lang=eng"

    Scenario: Successful create account

        When I click on the checkbox "Level 2"
        And I click on the checkbox "Force Authn"
        When I click on the link "Login"
        Then the url matches "https://rp1.tbstest.catslab.ca/RPSimulator/choose-eng.jsp"

        When I choose the CSP
        Then the element "Sign up with GCKey" is displayed
        # This is the Sign In Canada Acceptance Platform tailored for the ATIP application with the integration of the 2 current Credential Service Providers (GCKey and Sign-in Partner) links to their real Test Environments.
        When I click on the button "Sign up with GCKey"

        ## GCKey Welcome Page
        Then I should see "Welcome to GCKey"

        ## GCKey Terms and Conditions page
        When I click on the button "Sign Up"

        ## GCKey Create Your Username page.
        Then I should see "1 of 4"

        When I click on the button "I accept"
        Then I should see "2 of 4"

        When I have a valid random GCKey username <testuser>
        And I set the inputfield "Create Your Username" to <testuser>
        And I click on the button "Continue"
        And I pause for 1000ms
        Then I should see "3 of 4"

        # GCKey Create a Password page
        When I have a valid random GCKey password <testpassword>
        And I set the inputfield "Create Your Password" to <testpassword>
        And I set the inputfield "Confirm Your Password" to <testpassword>
        And I pause for 1000ms
        And I click on the button "Continue"
        Then I should see "4 of 4"

        ## GCKey Create Your Recovery Questions, Answers and Hints page

        When I select the option with the text "What was my first pet's name?" for the element "Select a Recovery Question"
        And I set the inputfield "My Recovery Answer" to "Fido"
        And I set the inputfield "My Memorable Person" to "Also Fido"
        And I set the inputfield "My Memorable Person Hint" to "dogsRpeople"
        And I set the inputfield "My Memorable Date" to "2000-01-01"
        And I set the inputfield "My Memorable Date Hint" to "Fido Day"
        And I click on the button "Continue"
        Then I should see "GCKey Sign Up Complete"

        When I click on the button "Sign Up Complete Continue"
#        Then the browser error log should be clear
# Then I should receive a CATS 2.0 cookie







