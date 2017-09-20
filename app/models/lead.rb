class Lead < ActiveRecord::Base
  include Comments
  belongs_to :channel
  belongs_to :status
  belongs_to :user
  belongs_to :ic_user, foreign_key: :ic_user_id, class_name: 'User'
  belongs_to :source, foreign_key: :source_id, class_name: 'LeadSource', optional: true

  has_many :attachments, :as => :owner

  has_paper_trail
  attr_accessor :first_comment
  after_save :send_changeset_email
  validates :info, presence: true

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

  def source_name
    source.try(:name)
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

  def status_wname
    status_id.nil? ? 'Без статуса' : status.try(:name)
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

  def self.chart_types
    [ {"id" => 'created_at', 'name' => 'Создано лидов'},
      {"id" => 'users_created_at', 'name'=> 'Создано сотрудниками'},
      {"id" => 'footage', 'name' => 'Метраж'},
      {"id" => 'statuses', 'name' => 'По статусам'} ]

  end

  def self.leads_users_count(type,start_date,end_date)

    data = {}
    range  = start_date.to_date..end_date.to_date
    period = range.map {|d| Date.new(d.year, d.month, 1) }.uniq


    case type
    when 'statuses'
      total = Lead.where('start_date between ? and ?',start_date,end_date).count
      data = Lead.group(:status_id)
                   .select(:status_id, "count(id) as count", '(Count(id)* 100 / '+total.to_s+') as percent' )
                   .where('start_date between ? and ?',start_date,end_date)
                   .order(:status_id)
                   .collect{ |lead| {label: lead.status_name, value: lead.count, present: lead.percent}}
                   .sort_by { |hsh| hsh[:value] }.reverse!
      
      headers = ['Статус','Количество','%']
      el = 'Donut'
    when 'created_at'

      data = period.each.collect{ |p|  {month:I18n.t(p.try('strftime',"%B")),  'Количество' => Lead.where("date_trunc('month', start_date) = ?",p).count } }
      headers = ['Количество']
      el= 'Bar'
    when 'footage'
      st = Status.find(10)
      data = period.each.collect{ |p|  {month:I18n.t(p.try('strftime',"%B")),
                                            'Всего' => Lead.where("date_trunc('month', start_date) = ?",p).sum(:footage),
                                             'Заключили договор' => st.leads.where("date_trunc('month', start_date) = ?",p).sum(:footage) } }
      data.map {|t| t["Заключили договор"].nil? || t["Заключили договор"]==0 ? 0 : t["Процент"] = t["Заключили договор"] * 100 / t["Всего"] }

      headers = ['Всего','Заключили договор','Процент']
      el= 'Area'
    when 'users_created_at'
      usr = User.where('id NOT IN (?)',[1,3]).order(:name)
      data = period.each.collect{ |p|  usr.collect{ |u| {month:I18n.t(p.try('strftime',"%B")),  u.name =>  u.leads.where("date_trunc('month', start_date) = ?",p).count } }.reduce(:merge) }
      headers = usr.map {|u| u.name }
      el= 'Bar'
    end

    { hash: data, json: data, headers: headers, element: el}
  end

end
