class PostsController < ApplicationController

    #index shows all posts
    get '/posts' do
      @posts = Post.all
      erb :'posts/index'
    end

    #grab the form to create a new post
    get '/posts/new' do
      if logged_in?
        erb :'posts/new'
      else
        redirect '/login'
    end

    #create a new post - based on the info gathered from the form in posts/new
    post '/posts' do
      if logged_in?
        if params[:post][:title] == "" || params[:post][:content] ==""
        else
          # this will assign an instance variable equal to the return value of calling the build method (from the class ActiveRecord::Base)
          # on the object created by calling the current_user method in ApplicationController class => @user
          # Since a user can have many posts, posts is also an attribute of the @user object.
          # => Return a new object created with attributes and set it to an instance variable
          @post = current_user.posts.build(title: params[:title], content: params[:content], author: params[:author])
          # if the post can be saved succesfully, redirect to the newly-created post
            if @post.save
              redirect '/posts/:slug'
          # if not be saved, redirect to the form to create a new post
            else
              redirect '/posts/new'
            end
        end
      else
        redirect '/login'
      end
    end

    #show a single post
    get '/posts/:slug' do
      @post = Post.find_by_slug(params[:slug])
      @user = @post.user
      erb :'/posts/show'
    end

    #grab the form to edit a post
    get '/posts/:slug/edit' do
      if logged_in?
        # Check if there was the post and if the post's author was the current user.
        # If there was, render the posts/edit page and present the edit form to the user.
        # Since a post belongs to a user, we can call the attribute user of a post object
        if @post && @post.user == current_user
          erb :'posts/edit'
        else
          #if there is no post matched the slug given and/or the current user wasn't the author, redirect to the posts index page
          redirect '/posts'
        end
      else
        redirect '/login'
      end
    end

    #update a post - based on the info gathered from the form in posts/edit
    patch '/posts/:slug' do
      if logged_in?
        # Check if any required box from the form is blank. If there is, redirect to get the edit form again.
        if params[:post][:title] == "" || params[:post][:content] == ""
          redirect '/posts/:slug/edit'
        else
          # If the form was filled correctly, find a post that match the slug
          # Find and assign the returned object to an instance variable
          @post = Post.find_by_slug(params[:slug])
          # After finding the match for a post, check if the post exist(?) and if the post belongs to the current user
          if @post && @post.user == current_user
            # If the user is authorized to edit the post, calling the update method on the current post object.
            if @post.update(title: params[:post][:title], content: params[:post][:content], author: params[:post][:author])
            # having #{@post.slug} will dynamically create a route corresponded to the current post
              redirect '/posts/#{@post.slug}'
            else
            # if the post can't be succesfully updated
              redirect '/posts/#{@post.slug}/edit'
            end
          else
            # if the user is not authorized to edit the post, redirect to the posts index page
            redirect '/post'
          end
        end
      else
        redirect '/login'
      end
    end

    #delete a post
    delete '/posts/:slug/delete' do
      if logged_in?
        @post = Post.find_by_slug(params[:slug])
        if @post && @post.user == current_user
          @post.delete
        end
          redirect '/posts'
      else
        redirect '/login'
      end
    end
  end
end
