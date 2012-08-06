class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings = params[:ratings]
    if @ratings.nil?
      if session[:ratings].nil?
        @selected_keys = ['N/A']
      else
        @ratings = session[:ratings]
        @selected_keys = @ratings.keys
      end
    else
      @selected_keys = @ratings.keys
      session[:ratings] = @ratings
    end
    if (params[:sort_column] == "title" || (params[:sort_column].nil? && session[:sort_column] == "title"))
      @movies = Movie.where({ :rating => @selected_keys }).order("title ASC").all
      @sort_column = "title"
      session[:sort_column] = "title"
    elsif (params[:sort_column] == "release_date" || (params[:sort_column].nil? && session[:sort_column] == "release_date"))
      @movies = Movie.where({ :rating => @selected_keys }).order("release_date ASC").all
      @sort_column = "release_date"
      session[:sort_column] = "release_date"
    else  # Both params[:sort_column] && session[:sort_column] are nil
      @movies = Movie.where({ :rating => @selected_keys }).all
      @sort_column = nil
    end
    if @ratings != params[:ratings] || @sort_column != params[:sort_column]
      flash.keep
      redirect_to movies_path(:sort_column => @sort_column, :ratings => @ratings)
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
