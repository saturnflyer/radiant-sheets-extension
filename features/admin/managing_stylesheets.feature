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
    And I should see "site.css"
    And I should see "sassy.sass"
    And I should see "Sass"
    And I should see "New Stylesheet"
  
  Scenario: Creating stylesheets
    Given I am logged in as "designer"
    When I go to the "styles" admin page
    And I follow "New Stylesheet"
    And I fill in "Slug" with "cuke.css"
    And I press "Create Stylesheet"
    Then I should see "Stylesheets"
    And I should see "cuke.css"
    And I should see "New Stylesheet"
    
  Scenario: Editing stylesheets
    When I go to "/css/site.css"
    Then the page should render
      """
      p { color: blue; }
      """
    When I am logged in as "designer"
    When I go to the "styles" admin page
    And I follow "site.css"
    And I fill in "Slug" with "changed.css"
    And I fill in "Body" with "p { color: red; } /* I added this comment */"
    And I press "Save Changes"
    Then I should see "changed.css"
    And I follow "Logout"
    And I go to "/css/changed.css"
    And the page should render
      """
      p { color: red; } /* I added this comment */
      """
      
  Scenario: Ensuring a homepage exists
    Given there are no pages
    And I am logged in as "designer"
    When I follow "Design"
    And I follow "Stylesheets"
    Then I should see "You must first publish a homepage before you may create a Stylesheet"
    And I should not see "New Stylesheet"
    And I should see "New Homepage"
      
  Scenario: Creating stylesheets from scratch
    Given there are no pages
    And I am logged in as "designer"
    When I follow "Design"
    And I follow "Stylesheets"
    Then I should see "You must first publish a homepage before you may create a Stylesheet"
    And I follow "New Homepage"
    And I fill in "Page Title" with "Home Page"
    And I fill in "Slug" with "/"
    And I fill in "Breadcrumb" with "Home"
    And I select "Published" from "Status"
    And I press "Create Page"
    Then I should see "Home Page"
    And I follow "Design"
    And I follow "Stylesheets"
    And I follow "New Stylesheet"
    Then I should see "Path: /css/"
    
  Scenario: Rendering CSS
    Given I am logged in as "designer"
    When I go to the "styles" admin page
    And I follow "New Stylesheet"
    And I fill in "Slug" with "styled.css"
    And I fill in the "Body" content with the text
      """
      body { color: red; }
      <r:stylesheet slug="site.css" />
      """
    And I press "Create Stylesheet"
    And I go to "/css/styled.css"
    Then the page should render
      """
      body { color: red; }
      p { color: blue; }
      """
      
  Scenario: Rendering Sass
    Given I am logged in as "designer"
    When I go to the "styles" admin page
    And I follow "New Stylesheet"
    And I fill in "Slug" with "sassed.css"
    And I fill in the "Body" content with the text
      """
      body
        font-size: 1em
      """
    And I select "Sass" from "Filter"
    And I press "Create Stylesheet"
    And I go to "/css/sassed.css"
    Then the page should render
      """
      body{font-size:1em}
      """
  
  Scenario: Rendering SCSS
    Given I am logged in as "designer"
    When I go to the "styles" admin page
    And I follow "New Stylesheet"
    And I fill in "Slug" with "sassed.css"
    And I fill in the "Body" content with the text
      """
      p { 
        a {
          color: blue;
          line-height: 1.9;
        }
        color: red;
      }
      """
    And I select "SCSS" from "Filter"
    And I press "Create Stylesheet"
    And I go to "/css/sassed.css"
    Then the page should render
      """
      p{color:red}p a{color:blue;line-height:1.9}
      """
    