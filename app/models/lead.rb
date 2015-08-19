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
    #grp_data1 = Lead.group_by_month(:status_date).collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), status_date: key}}
    #grp_data2 = Lead.group_by_month(:start_date).collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), start_date: key}}    
    #grp_data3 = Lead.group_by_month(:created_at).collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), created_at: key}}    
    #grp_data = (grp_data1+grp_data2+grp_data3).group_by{|h| h[:value]}.map{|k,v| v.reduce(:merge)}    
    #p grp_data
    #leads_data = grp_data.collect{|hash, key| {value: I18n.t(Date.parse(hash).strftime("%B")), count: key}.to_json }
    #grp_data = grp_data.collect{|hash, key| [I18n.t(Date.parse(hash).strftime("%B")), key] }
   # puts leads_data.to_s.gsub!(/\"{/, '{').gsub!(/}"/, '}').gsub!(/\\/, '')
 #  grp_data = {}
   # {hash: grp_data, json: grp_data, headers: ['Дата статуса','Дата создания','Создано']}
    #User.order(:name).collect{}
  end

  def self.chart_types
    [ {"id" => 'created_at', 'name' => 'Создано лидов'},
      {"id" => 'users_created_at', 'name'=> 'Создано сотрудниками'},
      {"id" => 'footage', 'name' => 'Метраж'},
       ]
    
  end

  def self.leads_users_count(type,start_date,end_date)

    data = {}
    #start_date = Date.new(2015,4,1)
    #end_date   = Date.new(2015,8,1)
    range  = start_date.to_date..end_date.to_date 
    period = range.map {|d| Date.new(d.year, d.month, 1) }.uniq

    
    case type
    when 'created_at'

      data = period.each.collect{ |p|  {month:I18n.t(p.try('strftime',"%B")),  'Количество' => Lead.where("date_trunc('month', created_at) = ?",p).count } }
      headers = ['Количество'] 
      el= 'bar'
    when 'footage'
      st = Status.find(10)
      data = period.each.collect{ |p|  {month:I18n.t(p.try('strftime',"%B")),                                              
                                            'Всего' => Lead.where("date_trunc('month', created_at) = ?",p).sum(:footage),
                                            'Заключили договор' => st.leads.where("date_trunc('month', created_at) = ?",p).sum(:footage) } }
                         
       headers = ['Всего','Заключили договор']          
      el= 'Area'
    when 'users_created_at'
      usr = User.where('id NOT IN (?)',[1,3]).order(:name)
      data = period.each.collect{ |p|  usr.collect{ |u| {month:I18n.t(p.try('strftime',"%B")),  u.name =>  u.leads.where("date_trunc('month', created_at) = ?",p).count } }.reduce(:merge) }
      headers = usr.map {|u| u.name }  
      el= 'Bar'
    end

    { hash: data, json: data, headers: headers, element: el}   
  end

end
