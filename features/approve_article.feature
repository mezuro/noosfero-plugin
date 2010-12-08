Feature: approve article
  As a community admin
  I want to approve an article
  In order to share it with other users

  Background:
    Given the following users
      | login | name |
      | joaosilva | Joao Silva |
      | mariasilva | Maria Silva |
    And the following articles
      | owner | name | body | homepage |
      | mariasilva | Sample Article | This is an article | true |
    And the following communities
      | identifier | name |
      | sample-community | Sample Community |
    And the articles of "Sample Community" are moderated
    And "Maria Silva" is a member of "Sample Community"
    And "Joao Silva" is admin of "Sample Community"

  Scenario: edit an article before approval
    Given I am logged in as "mariasilva"
    And I am on Maria Silva's homepage
    And I follow "Spread"
    And I check "Sample Community"
    And I press "Spread this"
    When I am logged in as "joaosilva"
    And I go to Sample Community's control panel
    And I follow "Process requests"
    And I fill in "Text" with "This is an article edited"
    And I press "Ok!"
    And I go to Sample Community's sitemap
    When I follow "Sample Article"
    Then I should see "This is an article edited"
