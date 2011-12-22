Feature: Voting Mechanism

  Background: Some posts
    Given a post exists
    #Given a post
    And I am logged in

  Scenario: User votes for a post from index
    Given I am on the home page
    Then I should see a link to vote for the post
    When I click the vote button
    Then the post should have received my vote
    
  Scenario: User votes from show page
    Given I am on the show page for the post
    Then I should see a link to vote for the post
    When I click the vote button
    Then the post should have received my vote
# should be able to see if user has already voted for a given post

  Scenario: Author checks scores
    Given I am a post author
    And that post has been voted for
    When I am on my profile page
    Then I should see "Reputation:"
    Then I should see "Votes: 1 votes worth 1.0 reputation"

# seeing vote count and score
# post editors and users to see their score?