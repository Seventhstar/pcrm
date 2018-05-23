class MyValidator < ActiveModel::Validator
  def validate(record)
    case record.reason_id
    when 0
      record.errors.add('Причина', "Должна быть указана")
    when 3
      record.errors.add('Магазины', "Добавьте хотя бы один") if record.shops.count==0 && record.id.present?
    when 6
      record.errors.add('Комментарий', "Должен быть заполнен") if record.comment.length <3
    else      
    end
  end
end

class Absence < ActiveRecord::Base
  extend ActiveModel::Naming

  belongs_to :reason, class_name: "AbsenceReason", foreign_key: :reason_id, optional: true
  belongs_to :new_reason, class_name: "AbsenceReason", foreign_key: :new_reason_id, optional: true
  belongs_to :target, class_name: "AbsenceTarget", foreign_key: :target_id, optional: true
  belongs_to :user
  belongs_to :project, optional: true
  has_many :shops, class_name: "AbsenceShop", foreign_key: :absence_id
  attr_accessor :t_from,:t_to, :checked, :reopen
  has_paper_trail

  validates_with MyValidator  
  validates :user, presence: true
  validates :project_id, presence: true, if: Proc.new { |p| p.project_id.nil? && (p.reason_id==2 || p.reason_id==3) }  
  validates :target_id, presence: true, if: Proc.new { |p| p.target_id.nil? && p.reason_id==2 } 

  def reason_name
    reason.try(:name)
  end

  def new_reason_name
    new_reason.try(:name)
  end

  def user_name
    user.try(:name)
  end

  def project_name
    project.try(:address) 
  end

  def target_name
    target.try(:name)
  end

  def self.counts_by_types(page_type, start_date, end_date)

    usr = User.where('id NOT IN (?)',[1,3,19]).order(:name)
    reasons = AbsenceReason.all.collect{ |u| {name: u.name, id: u.id} }
    reasons.insert(0, {name: 'Всего', id: 0})
    el = 'Bar'
    data_source = Absence.group(:user_id, :reason_id )
             .select(:user_id, :reason_id, "count(id) as count" )
             .where('dt_from between ? and ?', start_date, end_date)
             .order(:user_id, :reason_id)
             .collect{ |abs| {reason_id: abs.reason_id, user_id: abs.user_id, count: abs.count}}

    data = usr.collect{ |u|  
            reasons.collect{ |r| {
              month: u.name, 
              r[:name] => data_source.select{ |s| s[:user_id] == u.id && s[:reason_id] == r[:id] }
                                     .first.to_h[:count]
              }
            }
            .reduce(:merge) 
          }

    # p "data #{data.class} #{data[2]} #{data[2].keys} #{data[2].values[2..-1]} #{data[2].values.inject(0) { |sum, x| sum + x.to_i }}"
    data.map{|a| a['Всего'] = a.values[2..-1].inject(0) { |sum, x| sum + x.to_i } }      
    # p data_source
    # p data

    headers = reasons.map {|u| u[:name] }
    # p headers
    { hash: data, json: data, headers: headers, element: el}

  end


end
