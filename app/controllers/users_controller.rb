class UsersController < ApplicationController

  # grab the form to create a new user
  get '/signup' do
    if !logged_in?
      erb :'users/new'
    else
      redirect '/posts'
    end
  end

  # create a new user - based on the info gathered from the form in users/new
  post '/signup' do
    # this will check if any required info is left blank
    if params[:user][:username] == "" || params[:user][:email] == "" || params[:user][:password] ==""
      redirect :'/signup'

    else
      # this will create a new object and assign it to an instance variable in the User class
      @user = User.create(username: params[:user][:username], email: params[:user][:email], password: params[:user][:password])
      # this will log the user in and create a key-value pair for that user in the session hash
      # the value of the key is set to be the attribute 'id' of the newly-created object
      session[:user_id] = @user.id
      redirect '/users/:slug'
    end
  end

  # grab the login form
  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect '/users'
    end
  end

  # log the user in - based on the info gathered from the form in users/login
  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id  #log the user in
      redirect '/users/:slug'
    else
      redirect '/signup'
    end
  end

  # log the user out. This will clear their session.
  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  # show a single user - account page
  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

end
