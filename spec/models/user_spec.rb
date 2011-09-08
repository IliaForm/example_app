require 'spec_helper'

describe User do

  before(:each) do
    @attr = { :name => "Example User", 
              :email => "user@example.com",
              :password => "foobar",
              :password_confirmation => "foobar" }
  end

   describe 'relationships' do 
   	 before :each do
   	   @user = User.create!(@attr)
   	   @followed = Factory :user
   	 end
   	 
   	 it 'should respond relationships attribur' do
   	   @user.should respond_to :relationships
   	 end
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
     User.create!(@attr.merge(:email=>"user1@example.com"))
     user_with_duplicate_mail=User.new(@attr)
     user_with_duplicate_mail.should be_valid

   end
    
   it "should raject caps emails" do
     caps_mail=@attr[:email].upcase
     User.create!(@attr.merge(:email=>caps_mail))
     user_with_caps_mail=User.new(@attr)
     user_with_caps_mail.should_not be_valid
   end 

describe "admin attribute" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should respond to admin" do
      @user.should respond_to(:admin)
    end

    it "should not be an admin by default" do
      @user.should_not be_admin
    end

    it "should be convertible to an admin" do
      @user.toggle!(:admin)
      @user.should be_admin
    end
  end

describe "password validations" do

   it "should require password" do
     User.new(@attr.merge(:password=> "", :password_confirmation=>"")).should_not be_valid
   end 

   it "should require a matching password confirmation" do
     User.new(@attr.merge(:password_confirmation=>"other")).should_not be_valid
   end

   it "should reject short passwords" do
      short="s"* 5
      User.new(@attr.merge(:password=> short, :password_confirmation=>short)).should_not be_valid
   end

   it "should reject long passwords" do
      long="s"* 41
      User.new(@attr.merge(:password=> long, :password_confirmation=>long)).should_not be_valid
   end
  end 

describe "password encryption" do

    before(:each) do
      @user = User.create!(@attr)
    end

    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
 
    it "should set the incripted password" do
      @user.encrypted_password.should_not be_blank
    end

describe "has password metod" do
  
    it "the true password" do
      @user.has_password?(@attr[:password]).should be_true
    end

    it "wrong password" do
      @user.has_password?("invalid").should be_false
    end

  describe "authenticate method" do

      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end

      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end

      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should==@user
      end
    end
   end
  end

  describe 'microposts associatons' do
    before(:each) do
      @user = User.create(@attr)
      @mp1 = Factory(:micropost, :user => @user, :created_at => 1.day.ago)
      @mp2 = Factory(:micropost, :user => @user, :created_at => 1.hour.ago)
     end

     it 'should have metod feed' do
       @user.should respond_to(:feed)
     end
     
     it 'should return only his microposts' do
       @user.feed.include?(@mp1).should be_true
       @user.feed.include?(@mp2).should be_true
     end 

     it 'sohuld not include microposts ithers users' do
       @mp3 = Factory(:micropost, :user => Factory(:user, :email => Factory.next(:email)))
       @user.feed.include?(@mp3).should be_false
     end 
  
     it 'should have attribute microposts' do
     	 @user.should respond_to(:microposts)
     end

     it 'should have microposts in right order' do
       @user.microposts.should == [@mp2, @mp1]
     end

     it 'should destroy microposts of destroyed user' do
       @user.destroy
       [@mp1, @mp2].each do |micropost|
        lambda do
          Micropost.find(micropost.id)
         end.should raise_error(ActiveRecord::RecordNotFound)
        Micropost.find_by_id(micropost.id).should be_nil
       end
     end
   end
end


