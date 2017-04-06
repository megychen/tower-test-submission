require 'rails_helper'

feature "register and login", :type => :feature do

  scenario "register" do
    visit "/users/sign_up"  # 浏览注册页面


    expect(page).to have_content("Sign up")

    within("#new_user") do  # 填表单
      fill_in("Team name", with: "foobar", :match => :prefer_exact)
      fill_in("User name", with: "foobar name", :match => :prefer_exact)
      fill_in("Email", with: "foobar@example.com", :match => :prefer_exact)
      fill_in("Password", with: "12345678", :match => :prefer_exact)
      fill_in("Password confirmation", with: "12345678", :match => :prefer_exact)
    end

    click_button "Sign up"
    # 检查文字。这文字是 Devise 默认会放在 flash[:notice] 上的

    expect(page).to have_content("Welcome! You have signed up successfully")

    # 检查数据库里面最后一笔真的有刚刚填的资料

    user = User.last
    expect(user.email).to eq("foobar@example.com")
  end

  feature "login", :type => :feature do

  scenario "login and logout" do
    user = User.create!( :email => "foobar@example.com", :password => "12345678", :user_name => "foobar", :team_name => "footeam")

    visit "/users/sign_in"

    within("#new_user") do
      fill_in "Email", with: "foobar@example.com"
      fill_in "Password", with: "12345678"
    end

    click_button "Log in"  # 点击登入按钮

    expect(page).to have_content("Signed in successfully")

    click_link "登出"  # 点击主选单的登出超连结，出现必须登入才能操作的提示

    expect(page).to have_content("You need to sign in or sign up before continuing.")
  end

 end

end
