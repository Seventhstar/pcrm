module ProvidersHelper
  def site_link(url)
      link_to_unless url.nil?, url, "http://#{url}",:target => "_blank"
  end

  def colored_status(status)
  	if status
      content_tag :span, status.name, class: 'pstatus'+status.id.to_s
    else
       ""
    end
  end
end
