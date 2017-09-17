class FileController < ApplicationController
  require 'uri'
  respond_to :html, :json
  before_action :logged_in_user

  def del_file
    if params[:file_id]
      file = Attachment.find(params[:file_id])
      num_to_s = file.owner_id.to_s
      filename = Rails.root.join('public', 'uploads',file.owner_type,num_to_s,file.id.to_s+File.extname(file.name))
      File.delete(filename) if File.exist?(filename)
      file.destroy
    end
    render :nothing => true
  end

  def show
    @img = '/download/'+params[:path]
    respond_modal_with @img, location: root_path
  end

  def create_file
    if params[:file] || params[:files]
      folder = params[:owner_type].classify
      subfolder = params[:owner_id]
      uploaded_io = params[:file]

      name = uploaded_io.original_filename
      dir = Rails.root.join('public', 'uploads',folder,subfolder)

      FileUtils.mkdir_p(dir) unless File.exists?(dir)
      id = append_file(name)
      open(dir+(id.to_s+File.extname(name)), 'wb') do |file|
       file.write(uploaded_io.read)
     end
   end
   render layout: false, content_type: "text/html"
 end

  def append_file(filename) #,lead_id
    f = Attachment.new
    f.owner_id = params[:owner_id]
    f.owner_type = params[:owner_type].classify
    f.user_id = current_user.id
    f.name = filename
    f.save
    f.id
  end

  def download
    name = params[:extension].nil? ? params[:basename] : params[:basename]+"."+params[:extension]
    dir = Rails.root.join('public', 'uploads',params[:type],params[:id],name)
    f = Attachment.find(params[:basename])
    send_file dir, :disposition => 'attachment', :filename => f.name
  end

end
