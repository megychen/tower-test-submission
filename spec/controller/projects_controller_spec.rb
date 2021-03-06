require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  before do
    @team = Team.create!(name: "FOO")
    user = User.create!(:email => "foobar@example.com", :password => "12345678", :user_name => "foobar", :team_name => "footeam")
    @project = Project.create!(title: "project 1", description: "foo", user_id: user.id, team_id: @team.id)
    sign_in(user)
  end

  describe "#show" do
    it "can go to show page if has permission" do
      get :show, :id => @project.id, :team_id => @team.id
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end

    describe "redirect_to root_path if no permission" do
      before do
        #新建立一个user然后登入，然后到第一个user建的team下，发现没有权限呢，要的就是这个效果
        u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
        sign_in(User.last)
      end
      it "permission failed" do
        get :show, :id => @project.id, :team_id => @team.id
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end

  it "#new" do
    get :new, :team_id => @team.id
    expect(response).to have_http_status(200)
    expect(response).to render_template(:new)
  end

  describe "#edit" do
    it "has permission to edit" do
      get :edit, :id => @project.id, :team_id => @team.id
      expect(response).to have_http_status(200)
      expect(response).to render_template(:edit)
    end

    describe "redirect_to root_path if no permission" do
      before do
        #新建立一个user然后登入，然后到第一个user建的team下，发现没有权限呢，要的就是这个效果
        u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
        sign_in(User.last)
      end
      it "permission failed" do
        get :edit, :id => @project.id, :team_id => @team.id
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end


  describe "#create" do
    before do
      project = Project.new
      @project_params = { :title => "lll1", :description => "des", user_id: User.first.id, :team_id => @team.id }
    end

    it "creates records" do
      expect{ post :create, :team_id => @team.id, project: @project_params }.to change{ Project.all.size }.by(1)
    end

    it "redirect on success" do
      post :create, :team_id => @team.id, project: @project_params
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to team_path(@team)
    end

    it "redirect :new on fail" do
      allow_any_instance_of(Project).to receive(:save).and_return(false)
      post :create, :team_id => @team.id, project: @project_params
      expect(response).not_to have_http_status(302)
      expect(response).to render_template(:new)
    end

  end

  xdescribe "#update" do
    before do
      u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
      #sign_in(User.last)
      @project_params = { :title => "name"}
    end

    it "changes records" do
      post :update, :team_id => @team.id, :id => @project.id, project: @project_params
      expect(Project.find(@project[:id])[:title]).to eq("name")
    end

    it "redirect on success" do
      post :update, :team_id => @team.id, :id => @project.id, project: @project_params
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to team_project_path
    end

    it "redirect :edit on fail" do
      allow_any_instance_of(Project).to receive(:update).and_return(false)
      post :update, :team_id => @team.id, id: @project[:id]
      expect(response).not_to have_http_status(302)
      expect(response).to render_template(:edit)
    end
  end

  describe "#destroy" do
    before do
      @project_2= Project.first || Project.create(title: "project 2", description: "foo2", user_id: user.id, team_id: @team.id)
    end
    it "destroy record" do
      expect{ delete :destroy, team_id: @team[:id], id: @project.id }.to change{ Project.all.size }.by(-1)
    end

    it "redirect_to index after destroy" do
      delete :destroy, team_id: @team.id, id: @project[:id]
      expect(response).to have_http_status(302)
      expect(response).to redirect_to team_projects_path
    end

    describe "redirect_to root_path if no permission" do
      before do
        u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
        sign_in(User.last)
      end
      it "permission failed" do
        delete :destroy, team_id: @team.id, id: @project[:id]
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end
end
