require "#{Rails.root}/app/helpers/projects_helper"
include ProjectsHelper

namespace :prj_helper do

  task :total => :environment do
    @project = Project.find(135)
    @gts = 1
    pgt = Goodstype.find(3)
    total = get_project_goods_data(pgt)
    p total
    p total_on_currencies(total,1)
    p total_on_currencies(total,2)
    
  end

end
