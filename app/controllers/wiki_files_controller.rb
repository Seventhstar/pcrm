class WikiFilesController < ApplicationController
	before_action :logged_in_user
	def index

			if current_user.admin?
				@wiki_files = Attachment.where(owner_type: 'WikiRecord').order(:name) 
			else
				not_adm_ids = WikiRecord.where(admin: false).ids
      	@wiki_files = Attachment.where(owner_type: 'WikiRecord').
      							where(owner_id: not_adm_ids ).order(:name)
    	end
  end

end
