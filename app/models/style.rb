class Style < ActiveRecord::Base
  has_many :provider_styles
  has_many :providers, through: :provider_styles
  validates :name, :length => { :minimum => 3 }

  def self.tokens(query)
    styles = where("name like ?", "%#{query}%")
    if styles.empty?
      [{id: "<<<#{query}>>>", name: "Новый: \"#{query}\""}]
    else
      styles
    end
  end

  def self.ids_from_tokens(tokens)
    tokens.gsub!(/<<<(.+?)>>>/) { create!(name: $1).id }
    tokens.split(',')
  end

  attr_accessor :parents_count
  
  def parents_count
    self.try(:providers).count
  end

end
