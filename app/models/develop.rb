class Develop < ActiveRecord::Base
  belongs_to :project, class_name: 'DevProject', foreign_key: :project_id
  belongs_to :priority
  belongs_to :dev_status
  belongs_to :ic_user, foreign_key: :ic_user_id, class_name: 'User'
  has_many :files, class_name: 'DevelopsFile', foreign_key: :develop_id
  has_many :attachments, as: :owner
  has_many :tasks, class_name: 'DevTask'

  accepts_nested_attributes_for :tasks, allow_destroy: true
  
  scope :open_tasks, -> {where(dev_status_id: 1)}

  validates :name, length: { minimum: 3 }
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
     if version.event == "create"
        DevelopMailer.created_email(id).deliver_now
     else
        DevelopMailer.changeset_email(id).deliver_now
     end
  end

  def project_name
    project.try(:name)
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
