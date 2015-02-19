class Provider < ActiveRecord::Base
    has_many :provider_styles
    has_many :provider_budgets
    has_many :styles, through: :provider_styles
    has_many :budgets, through: :provider_budgets

    attr_reader :style_tokens
    attr_reader :budget_tokens
  
    def style_tokens=(tokens)
      self.style_ids = Style.ids_from_tokens(tokens)
    end

    def style_names
      self.styles.collect{ |t| t.name}.join(", ")
    end

    def budget_tokens=(tokens)
      self.style_ids = Style.ids_from_tokens(tokens)
    end

    def budget_names
      self.styles.collect{ |t| t.name}.join(", ")
    end
end
