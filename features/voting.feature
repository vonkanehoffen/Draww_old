Feature: Voting Mechanism

  Background: Some posts
    Given a post exists
    #Given a post
    And I am logged in

  Scenario: User votes up a post from index
    Given I am on the home page
    Then I should see a link to vote up the post
    When I vote up
    Then the post should have a positive score

  Scenario: User votes down a post from index
    Given I am on the home page
    Then I should see a link to vote down the post
    When I vote down
    Then the post should have a negative score
    
  Scenario: User votes from show page
    Given I am on the show page for the post
    Then I should see a link to vote down the post
    When I vote up
    Then the post should have a negative score
# should be able to see if user has already voted for a given post

  Scenario: User votes from show page
    Given I am on the show page for the post
    Then I should see a link to vote down the post
    When I vote down
    Then the post should have a negative score

  Scenario: Author checks scores
    Given I am a post author
    And that post has been voted for
    When I am on my profile page
    Then I should see "Reputation:"
    Then I should see "casting power of 2.0 for your votes"

# seeing vote count and score
# post editors and users to see their score?