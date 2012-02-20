Then /^I should see a link to vote up the post$/ do
#  binding.pry
  page.has_link?('Vote Up')
end

When /^I vote up$/ do
  #step 'I press "vote for this post"'
  page.find_link('Vote Up').click
  #page.links.detect{|l| l =~ /vote/}.click
end

Then /^I should see a link to vote down the post$/ do
  page.has_link?('Vote Down')
end

When /^I vote down$/ do
  page.find_link('Vote Down').click
end

Then /^the post should have a positive score$/ do
  Post.last.votes_count.should > 0
end

Then /^the post should have a negative score$/ do
  Post.last.votes_count.should < 0
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
