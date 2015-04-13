class Budget < ActiveRecord::Base
  has_many :provider_budgets
  has_many :providers, through: :provider_budgets

  def self.tokens(query)
    budgets = where("name like ?", "%#{query}%")
    if styles.empty?
      [{id: "<<<#{query}>>>", name: "Новый: \"#{query}\""}]
    else
      budgets
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
