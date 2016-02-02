class Develop < ActiveRecord::Base
  belongs_to :project, class_name: 'DevProject', foreign_key: :project_id
  belongs_to :priority
  belongs_to :dev_status
  belongs_to :ic_user, foreign_key: :ic_user_id, class_name: 'User'
  has_many :files, class_name: 'DevelopsFile', foreign_key: :develop_id
  has_many :attachments, :as => :owner
  validates :name, :length => { :minimum => 3 }
  has_paper_trail
  after_save :send_changeset_email

  include CommonHelper

  def self.search(search)
    if search
      se = search.mb_chars.downcase
 	    where('LOWER(name) LIKE LOWER(?) ', "%#{se}%")
    else
      all
    end

  end

  def send_changeset_email
     @version =  versions.last
     #puts "version.event: "+@version.event
     if version.event == "create"
        DevelopMailer.created_email(id).deliver_now
     else
        DevelopMailer.changeset_email(id).deliver_now
     end
  end

  def project_name
    dev_project.try(:name)
  end

  def priority_name
    priority.try(:name)
  end


  def status_name
    dev_status.try(:name)
  end


  def ic_user_name
    ic_user.try(:name)
  end

end
