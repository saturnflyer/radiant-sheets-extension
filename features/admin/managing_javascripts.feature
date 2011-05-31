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
    Then I should see "site.js"
    And I should see "New Javascript"
    
  Scenario: Creating javascripts
    Given I am logged in as "designer"
    When I go to the "scripts" admin page
    And I follow "New Javascript"
    And I fill in "Slug" with "cuke.js"
    And I press "Create Javascript"
    Then I should see "Javascripts"
    And I should see "cuke.js"
    And I should see "New Javascript"
    
  Scenario: Editing javascripts
    When I go to "/js/site.js"
    Then the page should render
      """
      alert("site!");
      """
    When I am logged in as "designer"
    When I go to the "scripts" admin page
    And I follow "site.js"
    And I fill in "Slug" with "changed.js"
    And I fill in "Body" with "alert('site changed!');"
    And I press "Save Changes"
    Then I should see "changed.js"
    And I follow "Logout"
    And I go to "/js/changed.js"
    And the page should render
      """
      alert('site changed!');
      """
    
  Scenario: Rendering Javascripts
    Given I am logged in as "designer"
    When I go to the "scripts" admin page
    And I follow "New Javascript"
    And I fill in "Slug" with "styled.js"
    And I fill in the "Body" content with the text
      """
      var s = {};
      <r:javascript slug="site.js" />
      """
    And I press "Create Javascript"
    And I go to "/js/styled.js"
    Then the page should render
      """
      var s = {};
      alert("site!");
      """
    