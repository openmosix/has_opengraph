 require 'test_helper'

class HasOpengraphTest < Test::Unit::TestCase
  load_schema

  class Movie < ActiveRecord::Base
    has_opengraph :title => :name,
    :url => :get_url,
    :image => :cover_image_url,
    :description => :descr,
    :type => "movie",
    :site_name => "moviesite.com"

    def get_url
      "http://moviesite.com/movies/under-siege-2"
    end
    
  end
  
  def setup
    @movie = Movie.new
    @movie.name = "Under Siege 2"
    @movie.cover_image_url = "http://path/to/image.jpg"
    @movie.descr = "Steve Segal tears it up & does not look back"
    @movie.save
  end


  def test_graph_fetch
    example = '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:type" content="movie"/><meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:description" content="Steve Segal tears it up &amp; does not look back"/><meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:title" content="Under Siege 2"/><meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:url" content="http://moviesite.com/movies/under-siege-2"/><meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:site_name" content="moviesite.com"/><meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:image" content="http://path/to/image.jpg"/>'
    assert_equal example, @movie.draw_opengraph
  end

  def test_like_button
    example = "<script src=\"http://connect.facebook.net/en_US/all.js#xfbml=1\"></script><fb:like href=\"http%3A%2F%2Fmoviesite.com%2Fmovies%2Funder-siege-2\" action=\"like\" colorscheme=\"light\" send=\"false\" layout=\"standard\" width=\"450\" show_faces=\"true\" font=\"\"></fb:like>"
    assert_equal example, @movie.like_button
  end

end
