class Style < ActiveRecord::Base
    has_many :provider_styles
    has_many :styles, through: :provider_styles

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

end
