require 'rails_helper'

RSpec.describe TodosController, type: :controller do
  before do
    @team = Team.create!(name: "FOO")
    user = User.create!(:email => "foobar@example.com", :password => "12345678", :user_name => "foobar", :team_name => "footeam")
    @project = Project.create!(title: "project 1", description: "foo", user_id: user.id, team_id: @team.id)
    @todo = Todo.create!(title: "task", user_id: user.id, project_id: @project.id)
    sign_in(user)
  end

  describe "#show" do
    it "can go to show page if has permission" do
      get :show, :id => @todo.id, :project_id => @project.id, :team_id => @team.id
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
        get :show, :id => @todo.id, :project_id => @project.id, :team_id => @team.id
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#edit" do
    it "has permission to edit" do
      get :edit, :id => @todo.id, :project_id => @project.id, :team_id => @team.id
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
        get :edit, :id => @todo.id, :project_id => @project.id, :team_id => @team.id
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end


  xdescribe "#create" do
    before do
      todo = Todo.new
      @todo_params = { :title => "task1", :description => "sdkckdjc", :user_id => nil, :deadline => "" }
    end

    it "creates records" do
      expect{ post :create, :project_id => @project.id, :team_id => @team.id, :todo => @todo_params }.to change{ Todo.all.size }.by(1)
    end

    it "redirect on success" do
      post :create, :project_id => @project.id, :team_id => @team.id, todo: @todo_params
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to team_project_path(@team, @project)
    end
  end

  describe "#update" do
    before do
      u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
      #sign_in(User.last)
      @todo_params = { :user_id => User.first.id }
    end

    it "changes records" do
      post :update, :id => @todo.id, :team_id => @team.id, :project_id => @project.id, todo: @todo_params
      expect(Project.find(@todo[:id])[:user_id]).to eq(1)
    end

    it "redirect on success" do
      post :update, :id => @todo.id, :team_id => @team.id, :project_id => @project.id, todo: @todo_params
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to team_project_path
    end
  end

  describe "#destroy" do
    before do
      @todo_2 = Todo.first || Todo.create(title: "task 2", description: "task2")
    end
    it "destroy record" do
      expect{ delete :destroy, :id => @todo.id, team_id: @team[:id], project_id: @project.id }.to change{ Todo.all.size }.by(-1)
    end

    it "redirect_to index after destroy" do
      delete :destroy, :id => @todo.id, team_id: @team.id, project_id: @project[:id]
      expect(response).to have_http_status(302)
      expect(response).to redirect_to team_project_path(@team, @project)
    end

    describe "redirect_to root_path if no permission" do
      before do
        u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
        sign_in(User.last)
      end
      it "permission failed" do
        delete :destroy, :id => @todo.id, team_id: @team.id, project_id: @project[:id]
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end
end
