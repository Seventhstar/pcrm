class Attachment < ActiveRecord::Base
 belongs_to :user
 belongs_to :owner, polymorphic: true
 has_paper_trail

  def download_path
    # ["/download",self.owner.class.name,self.owner.id,self.id.to_s+File.extname(self.name)].join("/")
    ['/download',self.id].join("/")
  end

  def show_path
    ['/files',self.id].join("/")
  end

end
