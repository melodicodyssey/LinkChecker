class SitesController < ApplicationController
  def new
    @site = Site.new
    respond_to do |f|
      f.html
      f.json {render :json => {:error => "NOPE"}, :status => 404}
    end
  end

  def create
    url = params.require(:site)[:url]
    @site = Site.create(url: url)
    LinksWorker.perform_async(@site.id)
    respond_to do |f|
      f.html { redirect_to site_path(@site) }
      f.json { render :json => @site }
    end
  end

  def show
    @site = Site.find(params[:id])

    @links = @site.links
    respond_to do |f|
      f.html
      f.json { render :json => @site, :include => :links }
    end
  end

  def edit
    site = Site.find(params[:id])
    respond_to do |f|
      f.html
      f.json {render :json => {:error => "NOPE"}, :status => 404}
    end
  end

  def delete
    site = Site.find(params[:id])
    site.delete
    respond_to do |f|
      f.html do
        redirect_to new_site_path
      end
      f.json {render :json => site}
    end
  end

  def linkfarm
    links = [
              {link: "https://www.yahoo.com", comment: "A Search Engine"},
              {link: "https://www.google.com", comment: "Another Search Engine"},
              {link: "https://www.amazon.com/testing/testing/testing", comment: "A Made Up Amazon URL"},
              {link: "https://www.google.com/mysite/that/doesnt/exist", comment: "A Search Engine with a bad link"}
            ]
    respond_to do |f|
      f.html {render :linkfarm}
      f.json {render :json => links}
    end
  end

  rescue_from ActionController::ParameterMissing, :only => :create do |err|
    respond_to do |f|
      f.html do 
        redirect_to new_site_path
      end
      f.json {render :json  => {:error => err.message}, :status => 422}
    end
  end

  # rescue_from ActionController::ParameterMissing, :handle_create_param_missing :only => :create
  #
  # def handle_create_param_missing
  #    respond_to do |f|
  #     f.html do 
  #       redirect_to new_site_path
  #     end
  #     f.json {render :json  => {:error => err.message}, :status => 422}
  #   end
  # #
end
