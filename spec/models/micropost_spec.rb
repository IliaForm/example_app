require 'spec_helper'

describe "Micropost" do

  before(:each) do
    @user = Factory(:user)
    @attr = { :content => "some content" }
  end

  describe "validations for microposts" do

  	it 'should require user_id' do
  	  Micropost.create(@attr).should_not be_valid
  	end

  	it 'should not have empty content' do
  	  @user.microposts.build(:content => " ").should_not be_valid
  	end

  	it 'should have content not longer than 140 chars' do
  	  @user.microposts.build(:content => "a" * 141).should_not be_valid
  	end
  end

  it "should create a new instance given valid attributes" do
    @user.microposts.create!(@attr)
  end

  describe "user associations" do

    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end

    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end

    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
  end
end