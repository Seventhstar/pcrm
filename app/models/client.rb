class Client < ActiveRecord::Base
  include Contacts
  has_many :projects
  belongs_to :city

  scope :by_city, ->(city){where(city: city)}
  scope :by_owner, ->(owner){where(id: owner.projects.pluck(:client_id)) if !owner.has_role?(:manager)}
  scope :by_search, ->(word){
    where('LOWER(name) like LOWER(?) or LOWER(address) like LOWER(?)',"%#{word}%","%#{word}%") if word.present?
  }

  validates :name, length: { minimum: 3 }

  def city_name
    city.try(:name)
  end

end
