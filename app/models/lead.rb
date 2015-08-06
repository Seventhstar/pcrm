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
    if updated_at > (Time.now-5) 
      @version = versions.last
      obj_ch = YAML.load(version['object_changes'])

      if version.event == "create"
        LeadMailer.created_email(id, first_comment).deliver_now
      elsif obj_ch['ic_user_id'].class == [].class
        LeadMailer.new_owner_email(id).deliver_now 
        LeadMailer.you_owner_email(id).deliver_now 
      else
        LeadMailer.changeset_email(id).deliver_now
      end
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

  def self.leads_count
    grp_data1 = Lead.group_by_month(:status_date).collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), status_date: key}}
    grp_data2 = Lead.group_by_month(:start_date).collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), start_date: key}}    
    grp_data3 = Lead.group_by_month(:created_at).collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), created_at: key}}    
    grp_data = (grp_data1+grp_data2+grp_data3).group_by{|h| h[:value]}.map{|k,v| v.reduce(:merge)}    
    p grp_data
    #leads_data = grp_data.collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), count: key}.to_json }
    #grp_data = grp_data.collect{|hash, key| [I18n.t(Date.parse(hash).strftime("%B")), key] }
   # puts leads_data.to_s.gsub!(/\"{/, '{').gsub!(/}"/, '}').gsub!(/\\/, '')
    {hash: grp_data, json: grp_data, headers: ['Дата статуса','Дата создания','Создано']}
  end

  def self.leads_users_count
    data = Lead.group(:ic_user_id, "datetime(start_date, 'start of month')")
        .select(:ic_user_id, "datetime(start_date, 'start of month') as month", "count(id) as f1")
        .order("datetime(start_date, 'start of month')")
        .where('start_date not null')
        .collect{ |lead| {month:I18n.t(Date.parse(lead.month).strftime("%B")), (lead.ic_user_id.nil? ? "none" : lead.ic_user_id) => lead.f1}}
        #.order("f1 DESC")
        #.collect{ |lead| [lead.ic_user_id, :month, lead.f1] } 
     { json: data, headers: ['Дата статуса','Дата создания','Создано']}   
  end

end
