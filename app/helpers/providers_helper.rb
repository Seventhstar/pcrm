module ProvidersHelper
  def site_link(url)
      link_to_unless url.nil?, url, "http://#{url}",:target => "_blank"
  end

  def colored_status(status)
  	if status
      content_tag :span, status.name, class: 'pstatus pst'+status.id.to_s
    else
       ""
    end
  end

 def providers_page_url
    session[:last_providers_page] || providers_url
 end


 def store_providers_path
    session[:last_providers_page] = request.url || providers_url if request.get?
 end

end
