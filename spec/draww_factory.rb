FactoryGirl.define do
  sequence :username do |n|
    "usernamed#{n+100}"
  end
  sequence :email do |n|
    "user#{n+100}@domain.net"
  end
  sequence :sext do |n|
    "a load of n (#{n}th edition)"
  end
  factory :user do
    username
    email
    password "cormorant"
    password_confirmation {|u| u.password }
    factory :hi_score_user do
      after_create { |u| Factory(:hi_score_post, :user => u)} 
    end
    factory :lo_score_user do
      after_create { |u| Factory(:lo_score_post, :user => u)} 
    end
  end
  factory :post do
    user
    title { FactoryGirl.generate(:sext) }#"dont even"
    description { FactoryGirl.generate(:sext) } #"quite unremarkable"
    photo File.new(Rails.root + 'spec/invisible_cormorant.png')
    factory :post_many_votes do
      after_create { |p| 5.times { Factory(:lo_point_vote, :post => p)}}
    end
    factory :post_one_vote do
      after_create { |p| Factory(:lo_point_vote, :post => p)}
    end
    factory :hi_score_post do
      after_create { |p| Factory(:hi_point_vote, :post => p)}      
    end
    factory :lo_score_post do
      after_create { |p| Factory(:lo_point_vote, :post => p)}      
    end
  end
  factory :vote do
    user #Factory(:author)
    post
    factory :lo_point_vote do
      points 1
    end
    factory :hi_point_vote do
      points 5
    end
    factory :old_vote do
      created_at 1.weeks.ago
      updated_at 1.weeks.ago
    end
    factory :older_vote do
      created_at 2.weeks.ago
      updated_at 2.weeks.ago
    end
    factory :oldest_vote do
      created_at 4.weeks.ago
      updated_at 4.weeks.ago
    end
  end
  
  factory :author, :parent => :user do
    author_score 5
  end
end
