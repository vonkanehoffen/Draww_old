require File.expand_path("../spec_helper.rb", __FILE__)

describe "Ranking Mechanism" do
  describe "Vote" do
    before(:each) do
      v = FactoryGirl.create(:vote)
    end
    it "should have a user" do
      v.user.class.should == User
    end
    it "should have a post" do
      v.post.class.should == Post
    end
  end
  describe User do
    before(:each) do
      @u = FactoryGirl.create(:user)
    end
    it "should have a total number of points" do
      @u.total_points.should == 0
    end
    it "should have a score" do
      @u.score.should == 0
    end
  end
  describe Post do
    before(:each) do
      p = FactoryGirl.create(:post)
    end
    it "should have a total number of votes" do
      p.total_votes.should == 0
    end
    it "should have a score" do
      p.score.should == 0
    end
  end
  describe "Scoring" do
    describe "Post Scores" do
      it "should be higher with more votes" do
        p = FactoryGirl.create(:post)
        old_score = p.score
        p.votes << FactoryGirl.create_list(:vote, 5)
        old_score.should < p.score
      end
      let(:low_score_user) do
        stub_model User, :score => 2
      end
      let(:high_score_user) do
        stub_model User, :score => 4
      end
      it "should be higher with votes from higher scoring users" do
        a,b = FactoryGirl.create_list(:post,2)
        low_score_user.vote!(a)
        high_score_user.vote!(b)
        a.score.should < b.score
      end
      it "should not give undue weight to a post with only one (100% positive) vote" do
        pending
      end
    end
    describe "User Scores" do
      it "should be higher with more (authored) post votes" do
        @u = FactoryGirl.create(:user)
        5.times do
          old_score = @u.score
          p = FactoryGirl.create(:post_with_votes)
          @u.posts << p
          @u.score.should > old_score
        end
      end
      it "should grant a higher ranking in post scores (weighting)" do
        pending "whether this is any different to Post spec"
      end
    end
    describe "Efficiency" do
      it "shouldn't take too long to calculate" do
        pending "Some method to compare poly/ exp time"
      end
    end
  end
end

