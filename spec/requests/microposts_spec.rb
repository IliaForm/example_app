require 'spec_helper'

describe "Microposts" do
   
  before(:each) do
    user = Factory(:user)
    visit signin_path
    fill_in :email,    :with => user.email
    fill_in :password, :with => user.password
    click_button
  end 

  it 'should test delete link' do
  	other_user = Factory :user, :email => Factory.next(:email)
  	micropost = Factory :micropost, :user => other_user
  	visit user_path(other_user)
  	response.should_not have_selector "a", :content => 'delete'
  end  


  describe "creation" do

    describe "failure" do

      it "should not make new micropost" do
        lambda do
          visit root_path
          fill_in 'txt', :with => ""
          click_button
          response.should render_template('pages/home')
          response.should have_selector("div#error_explanation")
        end.should_not change(Micropost, :count)
      end
    end

    describe "success" do

      it "should create new micropost" do
        content = 'some content'
        lambda do
          visit root_path
          fill_in 'txt', :with => content
          click_button
          response.should have_selector("span.content", :content => content)
        end.should change(Micropost, :count).by(1)
      end
    end
  end
end
