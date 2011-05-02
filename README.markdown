# has_opengraph
Easily generate [facebook opengraph](http://developers.facebook.com/docs/opengraph) data from your models

### Note:

This version it is a fork of (https://github.com/capotej/has_opengraph).
It works only with Rails 3.x (automatically safe_html!), and it supports:
  * facebook like button
  * facebook send button
  * facebook comments

### Installation
From your rails directory
    rails plugin install http://github.com/openmosix/has_opengraph.git

### Example Usage

#### Model: map opengraph values to fields/methods in your model
    class Movie < ActiveRecord::Base
      has_opengraph :title => :name,
                    :url => :get_url,
                    :image => :cover_image_url,
                    :description => :desc,
                    :type => "movie",
                    :site_name => "moviesite.com"
      def get_url
        self.permalink
      end
    end

#### Layout: yield to a :fb block in your layout for the opengraph tags we'll be drawing
    <html>
      <head>
        <%= yield :fb %>
      </head>
      <body>
        <%= yield %>
      </body>
    </html>    

#### View: Pass the opengraph meta tags to our content_for block
    <% content_for :fb do %>
      @movie.draw_opengraph
    <% end %>
    <div class="movie">
      <h1><%= @movie.title %></h1>
    </div>

#### View: Show the like button
    <div class="movie-comments">
      <span><%= @movie.like_button %></span>
    </div>

### View: Like button customization
  <div class="movie-comments">
    <span><%= @movie.like_button(:width=>300, :show_faces => false, :layout => "button_count", :action => "recommend", :font=>"tahoma") %></span>
  </div>
  
Parameters:

:width 
  The width of the like box, in pixel. Default: 450.
:show_faces
  Show the faces of friends that liked the item. Boolean true/false. Default: true.
:layout
  Layout type of the like button. Allowed values: "button_count", "box_count","standard". Default: "standard"
:action
  The verb of the like button. Allowed values: "recommend", "like". Default: "like"
:font
  The type of font being used. Allowed values: "tahoma", "arial", "lucida grande", "segoe ui", "trebuchet ms", "verdana"
:colorscheme
  The type of color scheme used to render the like box. Allowed values: "dark", "light".Default: "light"
:send_button
  Enable the send button. Boolean true/false. Default: false.
  
#### View: Show the send button
  <div class="movie-comments">
    <span><%= @movie.like_button(:send_button => true) %></span>
  </div>

### Add facebook comments
  <div class="movie-comments">
    <span><%= @movie.comments( :width=>600 ) %></span>
  </div>
  
Parameters:
:width 
  The width of the like box, in pixel. Default: 450.
:num_posts
  The number of comments to display below the comments box. Default: 3.
:colorscheme
  The type of color scheme used to render the like box. Allowed values: "dark", "light".Default: "light"
  
### License

Copyright (c) 2010 Julio Capote, released under the MIT license
