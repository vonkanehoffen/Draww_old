FactoryGirl.define do
  sequence :username do |n|
    "usernamed#{n}"
  end
  sequence :email do |n|
    "user#{n}@domain.net"
  end
 factory :user do
    username
    email
    password "cormorant"
    password_confirmation {|u| u.password }
  end
  factory :post do
    user
    title "dont even"
    description "quite unremarkable"
    photo File.new(Rails.root + 'spec/invisible_cormorant.png')
  end
  factory :vote do
    user
    post
  end
end
