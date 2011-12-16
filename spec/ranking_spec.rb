require File.expand_path("../spec_helper.rb", __FILE__)

describe "Ranking Mechanism" do
  describe Vote do
    before(:each) do
      @v = FactoryGirl.create(:vote)
    end
    it "should have a user" do
      @v.user.class.should == User
    end
    it "should have a post" do
      @v.post.class.should == Post
    end
    it "should have points" do
      @v.points.should be_a_kind_of(Numeric)
    end
    it "should have a higher points if the voter has higher casting power" do
      hv = FactoryGirl.create(:vote, :user => FactoryGirl.create(:hi_score_user) )
      lv = FactoryGirl.create(:vote, :user => FactoryGirl.create(:lo_score_user) )
      #binding.pry
      hv.points.should > lv.points
    end
  end
  describe User do
    before(:each) do
      @u = FactoryGirl.create(:user)
    end
    it "should have an authorship score" do
      @u.author_score.should be_a_kind_of(Numeric)
    end
    it "should have casting power" do
      @u.casting_power.should be_a_kind_of(Numeric)
    end
    it "should be able to vote" do
      vc = @u.votes.count
      p = FactoryGirl.create(:post)
      p.votes.empty?.should be_true
      @u.vote!(p)
      Post.find(p.id).votes.empty?.should_not be_true
      @u.votes.count.should > vc
    end
    it "should be granted higher casting power by authoring posts that get votes" do
      @u = FactoryGirl.create(:user)
      3.times do
        old_power = @u.casting_power
        p = FactoryGirl.create(:post_one_vote)
        @u.posts << p
        @u.casting_power.should > old_power
      end
    end
  end
  describe Post do
    before(:each) do
      @p = FactoryGirl.create(:post)
    end
    it "should have a total number of votes" do
      @p.votes_count.should be_a_kind_of(Numeric)
    end
    it "should have a score" do
      @p.votes_score.should be_a_kind_of(Numeric)
    end
    it "should have a higher score with more votes" do
      p = FactoryGirl.create(:post)
      old_score = p.votes_score
      p.votes << FactoryGirl.create_list(:vote, 5, :points=>1)
      old_score.should < p.votes_score
    end
    it "should have a higher score with votes from higher scoring users" do
      a,b = FactoryGirl.create_list(:post,2)
      FactoryGirl.create(:lo_score_user).vote!(a)
      FactoryGirl.create(:hi_score_user).vote!(b)
      a.votes_score.should < b.votes_score
    end
  end
  describe "Efficiency" do
    it "shouldn't take too long to calculate" do
      pending "Some method to compare poly/ exp time"
    end
  end
end

