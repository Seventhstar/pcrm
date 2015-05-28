class Develop < ActiveRecord::Base
  after_save :send_changeset_email
  belongs_to :dev_project, foreign_key: :project_id
  belongs_to :priority
  belongs_to :ic_user, foreign_key: :ic_user_id, class_name: 'User'
  has_many :files, foreign_key: :develop_id, class_name: 'DevFile'
  has_paper_trail


  def self.search(search)
    if search
      se = search.mb_chars.downcase
 	where('name LIKE ? ', "%#{se}%")
    else
      all
    end

  end

  def changeset_email
    DevelopMailer.changeset_email().deliver_now
  end

  def project_name
    dev_project.try(:name)
  end

  def priority_name
    priority.try(:name)
  end


  def ic_user_name
    ic_user.try(:name)
  end

end
