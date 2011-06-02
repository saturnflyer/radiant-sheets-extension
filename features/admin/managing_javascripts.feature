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
    And I should see "coffee.js"
    And I should see "Coffee"
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
    
  Scenario: Rendering CoffeeScript
    Given I am logged in as "designer"
    When I go to the "scripts" admin page
    And I follow "New Javascript"
    And I fill in "Slug" with "mocha.js"
    And I fill in the "Body" content with the text
      """
      # Assignment:
      number   = 42
      opposite = true

      # Conditions:
      number = -42 if opposite

      # Functions:
      square = (x) -> x * x

      # Arrays:
      list = [1, 2, 3, 4, 5]

      # Objects:
      math =
        root:   Math.sqrt
        square: square
        cube:   (x) -> x * square x

      # Splats:
      race = (winner, runners...) ->
        print winner, runners

      # Existence:
      alert "I knew it!" if elvis?

      # Array comprehensions:
      cubes = (math.cube num for num in list)
      """
    And I select "Coffee" from "Filter"
    And I press "Create Javascript"
    And I go to "/js/mocha.js"
    Then the page should render
      """
      (function() {
        var cubes, list, math, num, number, opposite, race, square;
        var __slice = Array.prototype.slice;
        number = 42;
        opposite = true;
        if (opposite) {
          number = -42;
        }
        square = function(x) {
          return x * x;
        };
        list = [1, 2, 3, 4, 5];
        math = {
          root: Math.sqrt,
          square: square,
          cube: function(x) {
            return x * square(x);
          }
        };
        race = function() {
          var runners, winner;
          winner = arguments[0], runners = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
          return print(winner, runners);
        };
        if (typeof elvis !== "undefined" && elvis !== null) {
          alert("I knew it!");
        }
        cubes = (function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = list.length; _i < _len; _i++) {
            num = list[_i];
            _results.push(math.cube(num));
          }
          return _results;
        })();
      }).call(this);
      """
    