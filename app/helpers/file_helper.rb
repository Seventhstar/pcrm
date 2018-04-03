module FileHelper

  def audio_file(lead)
    file = lead.attachments.select{ |f| ['mp3', 'ogg'].include?(f.name.last(3)) if !f.nil? }.first
  end

end
