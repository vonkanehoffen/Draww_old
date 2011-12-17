Feature: Voting Mechanism

  Background: Some posts
    Given a post exists
    And I am logged in

  Scenario: User votes for a post
    When I am on the home page
    Then I should see "votes" within ".post"
