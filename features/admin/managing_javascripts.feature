Feature: Managing javascripts
  In order to create, modify, and delete content from the website
  a content editor
  wants to manipulate javascripts in the admin interface
  
  Scenario: Limiting access
    Given I am logged in as "existing"
    When I go to the "scripts" admin page
    Then I should see "You must have developer or administrator privileges to edit javascripts."
  
  Scenario: Listing javascripts
    Given I am logged in as "designer"
    When I go to the "scripts" admin page
    Then I should see "Javascripts"
    And I should see "New Javascript"