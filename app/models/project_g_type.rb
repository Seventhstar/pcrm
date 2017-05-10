class ProjectGType < ActiveRecord::Base
    belongs_to :goodstype, foreign_key: :g_type_id
    has_many :goods, class_name: "ProjectGood", foreign_key: :project_g_type_id

   def goodstype_name
      goodstype.try(:name)
   end

end
