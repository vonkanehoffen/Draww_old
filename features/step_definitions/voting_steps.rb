Then /^I should see a link to vote for the post$/ do
#  binding.pry
  page.has_link?('vote')
end

When /^I click the vote button$/ do
  #step 'I press "vote for this post"'
  page.find_link('vote').click
  #page.links.detect{|l| l =~ /vote/}.click
end

Then /^the post should have received my vote$/ do
  Post.last.votes_count.should > 0
end

Given /^I am a post author$/ do
  FactoryGirl.create(:post, {:user => @current_user})
end

Given /^that post has been voted for$/ do
  @voter = FactoryGirl.create(:user, {:username => "Sycophant9000"})
  FactoryGirl.create(:vote, {:user => @voter, :post => Post.last})
end

#Given /^a post$/ do
#  @post = Factory.build(:post)
#  @post.save_without_session_maintenance
#end
