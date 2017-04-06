require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  before do
    user = User.create!(:email => "foobar@example.com", :password => "12345678", :user_name => "foobar", :team_name => "footeam")
    @team = Team.create(name: "test")
    @project = Project.create!(title: "project 1", description: "foo", user_id: user.id, team_id: @team.id)
    pm = Access.create!(user_id: user.id, project_id: @project.id)
    sign_in(user)
  end

  describe "#index" do
    it "can see project events if project member" do
      get :index, :team_id => @team.id
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end

    ###应该在controller里加权限设置，才会重导致首页
    describe "redirect_to root_path if no permission" do
      before do
        u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
        sign_in(u)
      end
      it "permission failed" do
        get :index, :team_id => @team.id
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end
end
