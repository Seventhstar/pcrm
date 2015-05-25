class Provider < ActiveRecord::Base
    has_many :provider_styles
    has_many :provider_budgets
    has_many :provider_goodstypes
    has_many :provider_managers
    has_many :comments, :as => :owner
    has_many :styles, through: :provider_styles
    has_many :budgets, through: :provider_budgets
    has_many :goodstypes, through: :provider_goodstypes
    belongs_to :p_status

    attr_reader :style_tokens
    attr_reader :budget_tokens
  
    def style_tokens=(tokens)
      self.style_ids = Style.ids_from_tokens(tokens)
    end

    def style_names
      self.styles.collect{ |t| t.name}.join(", ")
    end

    def budget_tokens=(tokens)
      self.budget_ids = Budget.ids_from_tokens(tokens)
    end

    def budget_names
      self.budgets.collect{ |t| t.name}.join(", ")
    end

    def goods_types_tokens=(tokens)
      self.goodstype_ids = GoodsType.ids_from_tokens(tokens)
    end

    def goods_type_names
      self.goodstypes.collect{ |t| t.name}.join(", ")
    end

    def p_status_name
      p_status.try(:name)
    end


end
