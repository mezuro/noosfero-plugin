Feature: browse enterprises
  As a noosfero user
  I want to browse enterprises

Background:
  Given the following enterprises
    | identifier | name       |
    | shop1      | Shoes Shop |
  And feature "disable_products_for_enterprises" is disabled on environment
  And feature "show_balloon_with_profile_links_when_clicked" is enabled on environment

Scenario: show all enterprises
  Given the following enterprises
    | identifier | name        |
    | shop2      | Fruits Shop |
  Given I am on /assets/enterprises
  Then I should see "Enterprises"
  And I should see "Shoes Shop"
  And I should see "Fruits Shop"

Scenario: show profile links button
  Given I am on /assets/enterprises
  Then I should see "Profile links" within "a.enterprise-trigger"
  And I should not see "Members"
  And I should not see "Agenda"

@selenium
Scenario: show profile links when clicked
  Given I am on /assets/enterprises
  When I follow "Profile links"
  Then I should see "Products" within "ul.menu-submenu-list"
  And I should see "Members" within "ul.menu-submenu-list"
  And I should see "Agenda" within "ul.menu-submenu-list"

@selenium
Scenario: go to catalog when click on products link
  Given I am on /assets/enterprises
  When I follow "Profile links"
  And I follow "Products" and wait
  Then I should be exactly on /catalog/shop1
