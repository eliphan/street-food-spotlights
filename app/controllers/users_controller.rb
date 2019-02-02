class UsersController < ApplicationController

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    if @user
      erb :'users/show'
    else
      redirect '/'
    end
  end

  get '/users/:slug/posts' do
    @user = current_user
    if @user
      @post = @user.posts
      erb :'/users/myposts'
    else
      redirect '/'
    end
  end

  get '/signup' do
    if !logged_in?
      erb :'users/new'
    else
      redirect '/posts'
    end
  end

  post '/signup' do
    if params[:user][:username] == "" || params[:user][:email] == "" || params[:user][:password] =="" 
      redirect :'/signup'
    else
      @user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    end
  end

  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect "/users/#{@user.slug}"
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:user][:username])
    if @user && @user.authenticate(params[:user][:password])
      session[:user_id] = @user.id  
      redirect "/users/#{@user.slug}"
    else
      redirect '/signup'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

end
