require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  before do
    #user = User.create!(:email => "foobar@example.com", :password => "12345678", :user_name => "foobar", :team_name => "footeam")
    @team_0 = Team.first
    @team_1 = Team.create!(name: "team1")
    sign_in(User.first)
    tm = TeamPermission.create!(user_id: User.first.id, team_id: @team_0.id) #建立一笔team permission的权限
  end

  describe "GET index page" do

    it "#index" do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "#show" do
    it "can go to show page if has permission" do
      get :show, id: @team_0[:id]
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
        get :show, id: @team_0[:id]
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end

  it "#new" do
    get :new
    expect(response).to have_http_status(200)
    expect(response).to render_template(:new)
  end

  describe "#edit" do
    it "has permission to edit" do
      get :edit, id: @team_0[:id]
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
        get :edit, id: @team_0[:id]
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end


  describe "#create" do
    before do
      team = Team.new
      @team_params = { :name => "name", user_id: User.first.id }
    end

    it "creates records" do
      expect{ post :create, team: @team_params }.to change{ Team.all.size }.by(1)
    end

    it "redirect on success" do
      post :create, team: @team_params
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to teams_path
    end

    it "redirect :new on fail" do
      allow_any_instance_of(Team).to receive(:save).and_return(false)
      post :create, team: @team_params
      expect(response).not_to have_http_status(302)
      expect(response).to render_template(:new)
    end

  end

  describe "#update" do
    before do
      @team_params = { :name => "name", user_id: User.first.id }
    end

    it "changes records" do
      post :update, team: @team_params, id: @team_0[:id]
      expect(Team.find(@team_0[:id])[:name]).to eq("name")
    end

    it "redirect on success" do
      post :update, team: @team_params, id: @team_1[:id]
      expect(response).not_to have_http_status(200)
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end

    it "redirect :edit on fail" do
      allow_any_instance_of(Team).to receive(:update).and_return(false)
      post :update, team: @team_params, id: @team_0[:id]
      expect(response).not_to have_http_status(302)
      expect(response).to render_template(:edit)
    end
  end

  describe "#destroy" do
    before do
      @team_2= Team.first || Team.create(:name => "name", user_id: User.first.id)
    end
    it "destroy record" do
      expect{ delete :destroy, id: @team_2[:id] }.to change{ Team.all.size }.by(-1)
    end

    it "redirect_to index after destroy" do
      delete :destroy, id: @team_2[:id]
      expect(response).to have_http_status(302)
      expect(response).to redirect_to root_path
    end

    describe "redirect_to root_path if no permission" do
      before do
        u = User.create!( :email => "foobar123@example.com", :password => "12345678", :user_name => "foobar123", :team_name => "footeam123")
        sign_in(User.last)
      end
      it "permission failed" do
        delete :destroy, id: @team_0[:id]
        expect(response).to have_http_status(302)
        expect(response).to redirect_to root_path
      end
    end
  end
end
