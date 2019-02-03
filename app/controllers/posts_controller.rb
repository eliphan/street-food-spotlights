class PostsController < ApplicationController

    get '/posts' do
      @posts = Post.all
      erb :'posts/index'
    end

    get '/posts/new' do
      if logged_in?
        erb :'posts/new'
      else
        redirect '/login'
      end
    end

    post "/posts" do
      if logged_in?
        if params[:post][:title] == "" || params[:post][:content] == ""
          redirect '/posts/new'
        else       
          @post = current_user.posts.build(title: params[:post][:title], content: params[:post][:content], author: params[:post][:author])    
            if @post.save
              redirect "/posts/#{@post.slug}"
            else
              redirect '/posts/new'
            end
        end
      else
        redirect '/login'
      end
    end

    get '/posts/:slug' do
      @post = Post.find_by_slug(params[:slug])
      @user = @post.user
      erb :"/posts/show"
    end

    get '/posts/:slug/edit' do
      if logged_in?
        @post = Post.find_by_slug(params[:slug])
        if @post && @post.user == current_user
          erb :'posts/edit'
        else
          redirect '/posts'
        end
      else
        redirect '/login'
      end
    end

    patch '/posts/:slug' do
      if logged_in?
        if params[:post][:title] == "" || params[:post][:content] == ""
          redirect "/posts/#{@post.slug}/edit"
        else
          @post = Post.find_by_slug(params[:slug])
          if @post && @post.user == current_user
            if @post.update(title: params[:post][:title], content: params[:post][:content], author: params[:post][:author])
              redirect "/posts/#{@post.slug}"
            else
              redirect "/posts/#{@post.slug}/edit"
            end
          else
            redirect '/post'
          end
        end
      else
        redirect '/login'
      end
    end

    get '/posts/:slug/delete' do
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
