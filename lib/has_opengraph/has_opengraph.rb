module HasOpenGraph

  def self.included(base)
    base.send :extend, ClassMethods
  end

  def fb_meta_tag(k,v)
    '<meta xmlns:og="http://opengraphprotocol.org/schema/" property="og:' << k.to_s << '" content="' << CGI.escapeHTML(v) << '"/>'
  end


  module ClassMethods
    # any method placed here will apply to classes, like Hickwall
    def has_opengraph(opts = {})
      cattr_accessor :opengraph

      title = opts[:title] || :title
      type = opts[:type] || :type
      description = opts[:description] || :description
      #guess url here later would be cool
      url = opts[:url] || :url
      image = opts[:image] || :image_url
      site = opts[:site_name] || :site_name
      
      self.opengraph = { :title => title, :type => type, :description => description, :url => url, :image => image, :site_name => site }
      send :include, InstanceMethods
    end
  end

  module InstanceMethods
    def draw_opengraph
      str = ''
      self.class.opengraph.each do |k,v|
        if v.class == Symbol
          if res = self.send(v)
            str << fb_meta_tag(k,res)
          end
        else
          str << fb_meta_tag(k,v)
        end
      end
      str
    end
    
    def like_button(opts = {})
      url = get_url
      return unless url

      width = opts[:width] || 450
      layout_type = opts[:layout] || "standard"
      show_faces = (opts.has_key? :show_faces) ? opts[:show_faces] : true
      send_button = (opts.has_key? :send_button) ? opts[:send_button] : false
      font = opts[:font] || ""
      action = opts[:action] || "like"
      colorscheme = opts[:colorscheme] || "light"

      "<script src=\"http://connect.facebook.net/en_US/all.js#xfbml=1\"></script><fb:like href=\"#{url}\" action=\"#{action}\" colorscheme=\"#{colorscheme}\" send=\"#{send_button}\" layout=\"#{layout_type}\" width=\"#{width}\" show_faces=\"#{show_faces}\" font=\"#{font}\"></fb:like>".html_safe
    end

    def comments(opts = {})
      url = get_url
      return unless url

      num_posts = opts[:num_posts] || 3
      width = opts[:width] || 450        
      colorscheme = opts[:colorscheme] || "light"

      "<script src=\"http://connect.facebook.net/en_US/all.js#xfbml=1\"></script><fb:comments href=\"#{url}\" num_posts=\"#{num_posts}\" colorscheme=\"#{colorscheme}\" width=\"#{width}\"></fb:comments>".html_safe
    end

  protected    
    def get_url
      url = self.class.opengraph[:url]
      return unless url

      if url.class == Symbol
        nurl = self.send(url)
      else
        nurl = url
      end
      es_url = CGI.escape(nurl)
    end
  end

end

ActiveRecord::Base.send :include, HasOpenGraph
