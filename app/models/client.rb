class Client < ActiveRecord::Base
  has_many :projects
  has_many :contacts, as: :contactable
  belongs_to :city

  accepts_nested_attributes_for :contacts
  # validates :name, length: { minimum: 3 } 

  scope :by_city, ->(city){where(city: city)}
  
  scope :by_search, ->(word){
    where('LOWER(name) like LOWER(?) or LOWER(address) like LOWER(?)',"%#{word}%","%#{word}%") if word.present?
  }

  scope :by_owner, ->(owner){where(id: owner.projects.pluck(:client_id)) if !owner.has_role?(:manager)}


  def city_name
    city.try(:name)
  end

end
