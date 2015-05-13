class Lead < ActiveRecord::Base
  belongs_to :channel
  belongs_to :status
  belongs_to :user
  belongs_to :ic_user, foreign_key: :ic_user_id, class_name: 'User'
  has_many :leads_comments
  has_many :leads_files
  has_paper_trail
  attr_accessor :first_comment

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

  def user_name=(name)
    self.users = User.find_or_create_by_name(name) if name.present?
  end

end
