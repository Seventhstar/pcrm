class Provider < ActiveRecord::Base
  has_many :provider_styles
  has_many :provider_budgets
  has_many :provider_goodstypes
  has_many :provider_managers
  has_many :comments, as: :owner
  has_many :styles, through: :provider_styles
  has_many :budgets, through: :provider_budgets
  has_many :goodstypes, through: :provider_goodstypes
  has_many :receipts

  has_many :special_infos, as: :specialable, dependent: :destroy
  accepts_nested_attributes_for :special_infos

  belongs_to :p_status
  belongs_to :city
  has_paper_trail

  scope :by_city, ->(city){where(city: city)}

  attr_reader :style_tokens
  attr_reader :budget_tokens
  
  def style_tokens=(tokens)
    self.style_ids = Style.ids_from_tokens(tokens)
  end

  def full_info
    info = self.name
    info = info + "\n Адрес: " + self.try(:address) if self.try(:address).present?
    info = info + "\n Телефон: " + self.try(:phone) if self.try(:phone).present?

    managers = self.provider_managers.where(position_id: 2)
    info = info + "\n Менеджеры: " if managers.count>0
    managers.each do |m|
      info = info + "\n" + m.name
      info = info + " " + m.phone if m.phone.present?
      info = info + " " + m.email if m.email.present?
    end
    # [,, self.try(:phone)].copact.join(', ')
    info
  end

  def style_names
    self.styles.pluck(:name).join(", ")
  end

  def budget_tokens=(tokens)
    self.budget_ids = Budget.ids_from_tokens(tokens)
  end

  def budget_names
    self.budgets.pluck(:name).join(", ")
  end

  def goods_types_tokens=(tokens)
    self.goodstype_ids = GoodsType.ids_from_tokens(tokens)
  end

  def goods_type_names
    self.goodstypes.pluck(:name).join("<br>")
  end

  def p_status_name
    p_status.try(:name)
  end
end
