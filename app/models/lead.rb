class Lead < ActiveRecord::Base
  belongs_to :channel
  belongs_to :status
  belongs_to :user
  belongs_to :ic_user, foreign_key: :ic_user_id, class_name: 'User'
  has_many :comments, :as => :owner
  has_many :files, class_name: 'LeadsFile'
  has_paper_trail
  attr_accessor :first_comment
  after_save :send_changeset_email


  def send_changeset_email
     @version = versions.last
     puts "version.event: "+@version.event
     obj_ch = YAML.load(version['object_changes'])
    if version.event == "create"
    #   LeadMailer.created_email(id).deliver_now
    elsif obj_ch['ic_user_id'].class == [].class
      LeadMailer.new_owner_email(id).deliver_now 
      LeadMailer.you_owner_email(id).deliver_now 
    else
       LeadMailer.changeset_email(id).deliver_now
    end
  end


  def channel_name
    channel.try(:name)
  end

  def channel_name=(name)
    self.channel = Channel.find_or_create_by_name(name) if name.present?
  end


  def status_name
    status.try(:name)
  end

  def status_name=(name)
    self.status = Status.find_or_create_by_name(name) if name.present?
  end


  def user_name
    user.try(:name)
  end

  def ic_user_name
    ic_user.try(:name)
  end

  def short_info
     if info.length>50
        info[0..50]+' ...'
     else
	info
     end
  end


  def user_name=(name)
    self.users = User.find_or_create_by_name(name) if name.present?
  end

end
