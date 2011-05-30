Feature: Managing stylesheets
  In order to create, modify, and delete content from the website
  a content editor
  wants to manipulate stylesheets in the admin interface
  
  Scenario: Limiting access
    Given I am logged in as "existing"
    When I go to the "styles" admin page
    Then I should see "You must have developer or administrator privileges to edit stylesheets."
  
  Scenario: Listing stylesheets
    Given I am logged in as "designer"
    When I go to the "styles" admin page
    Then I should see "Stylesheets"
    And I should see "New Stylesheet"