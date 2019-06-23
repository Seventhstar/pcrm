class Goodstype < ActiveRecord::Base
  has_many :provider_goodstypes
  has_many :providers, through: :provider_goodstypes, source: :owner, source_type: 'Provider' 
  has_many :providers_groups, through: :provider_goodstypes, source: :owner, source_type: 'ProvidersGroup' 
  has_many :goods, class_name: 'ProjectGood'
  validates :name, length: { minimum: 3 }

  attr_accessor :parents_count
  
  def parents_count
    self.try(:providers).count
  end

end
