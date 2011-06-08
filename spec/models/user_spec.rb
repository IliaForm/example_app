require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", :email => "user@example.com" }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should create a new user with valid attributes" do
     User.create!(@attr)
  end
  
  it "should require email" do
    no_name_user= User.new(@attr.merge(:email=> ""))
    no_name_user.should_not be_valid
  end 
  
  it "should canceled too long names" do
    long_name="s" * 51
    too_long_user=User.new(@attr.merge(:name=> long_name))
    too_long_user.should_not be_valid
  end

  it "should accept valid email addresses" do
     addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
     addresses.each do |address|
       valid_email_user = User.new(@attr.merge(:email => address))
       valid_email_user.should be_valid
     end
   end

   it "should reject invalid email addresses" do
     addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
     addresses.each do |address|
       invalid_email_user = User.new(@attr.merge(:email => address))
       invalid_email_user.should_not be_valid
     end
   end
  
   it "should reject duplicate email addresses" do
     User.create!(@attr)
     user_with_duplicate_mail=User.new(@attr)
     user_with_duplicate_mail.should_not be_valid

   end
    
   it "should raject caps emails" do
     caps_mail=@attr[:email].upcase
     User.create!(@attr.merge(:email=>caps_mail))
     user_with_caps_mail=User.new(@attr)
     user_with_caps_mail.should_not be_valid
   end 
end
