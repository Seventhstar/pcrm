class PagesController < ApplicationController
  def show
    #render template: "pages/#{params[:page]}"
    @page_type = params[:page_type].nil? ? "created_at": params[:page_type]
    p params
    p "@page_type:"+@page_type.to_s
  end
end
