class Provider < ActiveRecord::Base
    has_many :provider_styles
    has_many :styles, through: :provider_styles

    attr_reader :styletokens
  
  def styletokens=(tokens)
    self.style_ids = Style.ids_from_tokens(tokens)
  end

  def style_names
    self.styles.collect{ |t| t.name}.join(", ")
  end

end
