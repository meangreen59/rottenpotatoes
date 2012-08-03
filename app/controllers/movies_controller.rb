class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings = params[:ratings]
    if params[:ratings].nil?
      @selected_keys = nil
    else
      @selected_keys = @ratings.keys
    end
    if (params[:sort_column] == "title")
      @movies = Movie.where({ :rating => @selected_keys }).order("title ASC").all
      @sort_column = :title
    elsif (params[:sort_column] == "release_date")
      @movies = Movie.where({ :rating => @selected_keys }).order("release_date ASC").all
      @sort_column = :release_date
    else  # params[:sort_column] == "default"
      @movies = Movie.where({ :rating => @selected_keys }).all
      @sort_column = nil
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort_column => "default")
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
    redirect_to movies_path(:sort_column => "default")
  end

end
