class ProviderManager < ActiveRecord::Base
  belongs_to :provider
  belongs_to :position
  validates :name, length: { minimum: 3 }



  def position_name
    position.try(:name)
  end
end
