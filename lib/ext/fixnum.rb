class Fixnum
  def to_sum
    self.to_s(:delimited, :delimiter => " ")
  end
end