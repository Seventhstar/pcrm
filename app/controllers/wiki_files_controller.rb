class WikiFilesController < ApplicationController
  before_action :logged_in_user
  def index
      params.delete_if{|k,v| v=='' || v=='0' }
      if !params[:wiki_cat_id].nil? && params[:wiki_cat_id]!=0
        @wiki_records = WikiRecord.where(wiki_cat_id: params[:wiki_cat_id])
      end
      @wiki_records = WikiRecord.all if @wiki_records.nil?
      
      @wiki_cats    = WikiCat.order(:name)
      
      @wr_ids = @wiki_records.ids

      if current_user.admin?
        non_adm_ids = @wiki_records.where(admin: false).ids 
        @wr_ids = non_adm_ids & @wr_ids
      end

      @wiki_files = Attachment.where(owner_type: 'WikiRecord').where(owner_id: @wr_ids ).order(:name)

      if !params[:search].nil? && params[:search]!=""
        info =params[:search]
        @wiki_files = @wiki_files.where('LOWER(name) like LOWER(?) ','%'+info+'%')
      end
  end

end
