class Attachment < ActiveRecord::Base
 belongs_to :user
 belongs_to :owner, :polymorphic => true
 has_paper_trail



 def download_path(owner)
 	["/download",owner.class.name,owner.id,self.id.to_s+File.extname(self.name)].join("/")
 end

 def show_path(owner)
	['/file',self.id.to_s+'?path='+owner.class.name,owner.id,self.id.to_s+File.extname(self.name)].join("/")
 end

end
