class Lead < ActiveRecord::Base
  include Comments
  belongs_to :user
  belongs_to :status
  belongs_to :channel
  belongs_to :priority
  belongs_to :ic_user, foreign_key: :ic_user_id, class_name: 'User'
  belongs_to :source, foreign_key: :source_id, class_name: 'LeadSource', optional: true
  belongs_to :city
  
  has_many :attachments, as: :owner

  scope :by_city,     ->(city){where(city: city)}
  scope :by_priority, ->(priority) {where(priority_id: priority) if priority.present? && priority&.to_i>0}
  scope :only_actual, ->(actual){where(status_id: Status.where(actual: true).ids) if actual}
  scope :by_year,     ->(year){where(status_date: Date.new(year.to_i,1,1)..Date.new(year.to_i,12,31)) if year.present? && year&.to_i>0}
 
  attr_accessor :first_comment
  after_save :send_changeset_email
  has_paper_trail

  def send_changeset_email
    if updated_at > (Time.now-5)
      @version = versions.last
      obj_ch = YAML.load(version['object_changes'])

      if version.event == "create"
        LeadMailer.created_email(id, first_comment).deliver_later
      elsif obj_ch['ic_user_id'].class == [].class
        TelegramWorker.perform_async id
        LeadMailer.new_owner_email(id).deliver_later
        LeadMailer.you_owner_email(id).deliver_later
      else
        LeadMailer.changeset_email(id).deliver_later
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

  def priority_name
    self&.priority&.name
  end

  def user_name=(name)
    self.users = User.find_or_create_by_name(name) if name.present?
  end

  def self.leads_users_count(type, start_date, end_date, diagram_type)

    data = {}
    range  = start_date.to_date..end_date.to_date
    period = range.map {|d| Date.new(d.year, d.month, 1) }.uniq

    months = I18n.t('date.month_names_full').compact

    current_year = period[0].year
    current_year = period[0].year.to_s
    last_year = (period[0].year - 1).to_s
    to_project = 'Заключили договор ' + current_year.to_s
    to_project_year = 'Заключили договор ' + last_year

    donut_headers = ['label', 'value']
    xkey = 'month'
    gxs2 = nil

    case type

    when 'created_at' #

      to_project_year = 'Заключили договор ' + last_year

      st = Status.find(10)
      headers = diagram_type == 'Donut' ? donut_headers : ['month', current_year]
      data = period.each.collect{ |p|  {
        headers[0] => I18n.t(p.try('strftime',"%B")),  
        headers[1] => Lead.where("date_trunc('month', start_date) = ?", p).count,
        to_project => st.leads.where("date_trunc('month', start_date) = ?", p).count,
        'Процент' => 0,
        last_year => Lead.where("date_trunc('month', start_date) = ?", p - 1.year).count,
        to_project_year => st.leads.where("date_trunc('month', start_date) = ?", p - 1.year).count,
        'Процент_1' => 0
      }}
            
      gxs  = [current_year, last_year]

      data.map {|t| 
        t["Процент"] = (t[to_project].nil? || t[headers[1]].nil? || 
                       t[to_project] == 0 || t[headers[1]] == 0) ? 0 : t[to_project] * 100 / t[headers[1]] 
        # puts "t['Процент'] #{t['Процент']}"
        t["Процент_1"] = t[to_project_year].nil? || t[to_project_year] == 0 ? 0 : t[to_project_year] * 100 / t[last_year] 
      }

      xs   = { period[0].year    => [ 'Количество (шт)', 'Заключили договор', '% заключивших'],
              (period[0].year-1) => [ 'Количество (шт)', 'Заключили договор', '% заключивших']}

      totals = [headers[1], to_project, '=totals[to_project]*100/totals[headers[1]]', 
                last_year, to_project_year, '=totals[to_project_year]*100/totals[last_year]'] 

      el = 'Area'

    when 'users_created_at' # 
      usr = User.actual.not_test

      data = usr.collect{ |u| period.each.collect{|p|{ 
              month: u.name, 
              id: u.id,
              I18n.t(p.try('strftime',"%B")) => u.leads.where("date_trunc('month', start_date) = ?", p).count } }
              .reduce(:merge) }

      xs = months
      xs = months
      el = 'Bar'

    when 'statuses'

      headers = diagram_type == 'Donut' ? donut_headers : ["Статус", "Количество"]
      total = Lead.where('start_date between ? and ?', start_date, end_date).count
      data = Lead.group(:status_id)
                   .select(:status_id, "count(id) as count", '(Count(id)* 100 / '+total.to_s+') as percent' )
                   .where('start_date between ? and ?', start_date, end_date)
                   .order(:status_id)
                   .collect{ |lead| {headers[0] => lead.status_name, headers[1] => lead.count, present: lead.percent}}
                   .sort_by { |hsh| hsh[headers[1]] }.reverse!
      
      # puts "data #{data}"
      xs = ['Статус', 'Количество', '%']
      xkey = 'Статус'
      gxs = ['Количество']
      el = 'Donut'
    
    when 'channels_donut'

      st = Status.find(10)
      total = Lead.where('start_date between ? and ?', start_date, end_date).count

      gxs = ['Канал', 'Количество']
      headers = diagram_type == 'Donut' ? donut_headers : gxs
      data = Channel.all.each.collect{|c| {
        headers[0] => c.name,
        headers[1] => c.leads.where('extract(year from start_date) = ?', current_year).count,
        'Прошлый год' => c.leads.where('extract(year from start_date) = ?', last_year).count,
        'Заключили договор' => c.leads.where('status_id = 10 AND extract(year from start_date) = ?', current_year).count,
        'Процент' => (c.leads.where('extract(year from start_date) = ?', current_year).count * 100 / total)}}
        .sort_by { |h| h['Процент'] }.reverse!

      xs = ['Канал', 'Количество', 'Прошлый год', 'Заключили договор', '%']
      gxs = ['Количество']
      el = 'Donut'
      xkey = 'Канал'

    when 'channels'
      
      # gxs = ['month', 'Количество']
      headers = diagram_type == 'Donut' ? donut_headers : ['month', 'Количество']

      st = Status.find(10)
      data = period.each.collect{ |p| 
              Channel.order(:name).each.collect{ |c| {
                headers[0] => I18n.t(p.try('strftime',"%B")),
                c.name => c.leads.where("date_trunc('month', start_date) = ?", p).count
            }}.reduce(:merge) }

      xs = Channel.order(:name).pluck(:name)
      el = 'Bar'

    when 'footage'

      st = Status.find(10)

      # last_year       = last_year + "й"

      data = period.each.collect{ |p| {
              month: I18n.t(p.try('strftime',"%B")), 
              current_year => Lead.where("date_trunc('month', start_date) = ?",p).sum(:footage),
              to_project => st.leads.where("date_trunc('month', start_date) = ?", p).sum(:footage),
              'Процент' => 0,
              last_year => Lead.where("date_trunc('month', start_date) = ?", p - 1.year).sum(:footage),
              to_project_year => st.leads.where("date_trunc('month', start_date) = ?", p - 1.year).sum(:footage),
              'Процент_1' => 0 } }

      data.map {|t| 
        t["Процент"] = t[to_project].nil? || t[to_project] == 0 ? 0 : t[to_project] * 100 / t[current_year] 
        t["Процент_1"] = t[to_project_year].nil? || t[to_project_year] == 0 ? 0 : t[to_project_year] * 100 / t[last_year] 
      }
      

      gxs  = [current_year, last_year]
      gxs2 = [to_project, to_project_year]
      xs   = { period[0].year => [ 'Всего', 'Заключили договор', 'Процент'],
              (period[0].year-1) => [ 'Всего', 'Заключили договор', 'Процент']}

      totals = [current_year, to_project, '=totals[to_project]*100/totals[current_year]', 
                last_year, to_project_year, '=totals[to_project_year]*100/totals[last_year]'] 

      el = 'Area'

    end

    result = {hash: data, json: data, xs: xs, element: el, xkey: xkey, gxs: gxs.nil? ? xs : gxs, gxs2: gxs2} 
    if !totals.nil?
      totals = totals.map{|t| {t => 0}}.reduce(:merge)
      totals.each do |k, v|
        if k.include?('=') 
          totals[k] = (eval k[1..-1])
        else
          data.each do |d|
            totals[k] += (k.strip.empty? || d[k].nil? ? 0 : d[k] )
          end
        end
      end
      result[:totals] = totals           # puts "totals #{totals}"
    end
    
    result
  end

end
