class FilesController < ApplicationController
  require 'uri'
  respond_to :html, :json
  before_action :logged_in_user

  def destroy
    if params[:id]
      @file = Attachment.find(params[:id])
      num_to_s = @file.owner_id.to_s
      filename = Rails.root.join('public', 'uploads',@file.owner_type,num_to_s,@file.id.to_s+File.extname(@file.name))
      File.delete(filename) if File.exist?(filename)
      @file.destroy
    end
    render :nothing => true
  end

  def create
    if params[:files]
      folder = params[:owner_type].classify
      subfolder = params[:owner_id]
      uploaded_io = params[:files]

      name = uploaded_io.original_filename
      dir = Rails.root.join('public', 'uploads',folder,subfolder)

      FileUtils.mkdir_p(dir) unless File.exists?(dir)
      p "name #{name}"
      id = append_file(name)
      open(dir+(id.to_s+File.extname(name)), 'wb') do |file|
       file.write(uploaded_io.read)
     end
   end
   # render layout: false, content_type: "text/html"
 end

  def append_file(filename) #,lead_id
    @file = Attachment.new
    @file.owner_id   = params[:owner_id]
    @file.owner_type = params[:owner_type].classify
    @file.user_id    = current_user.id
    @file.name       = filename
    @file.save
    @file.id

  end

  def show
    @file = Attachment.find(params[:id])
    # p "file: " + @file.to_json
    # owner.class.name,owner.id,self.id.to_s+File.extname(self.name)
    @img = ['/download/',@file.owner_type,@file.owner.id,@file.id.to_s+File.extname(@file.name)].join('/')
    respond_modal_with @img, location: root_path
  end

  def download
    name = params[:extension].nil? ? params[:basename] : params[:basename]+"."+params[:extension]
    dir = Rails.root.join('public', 'uploads',params[:type],params[:id],name)
    f = Attachment.find(params[:basename])
    send_file dir, disposition: 'attachment', filename: f.name
  end

end