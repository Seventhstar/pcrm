namespace :update_provider do
  task group: :environment do
    Provider.where(is_group: true).each do |g|
      if g.providers.first.nil? 
        puts "delete #{g.name}"
        g.delete
      else
        puts "group #{g.name}, first  #{g.providers.first.name}"
        # gts = g.providers.first.goodstype_ids
        gts = g.providers.first.goodstypes
        # puts gts.pluck(:goodstype_id, :name)
        puts "gts #{gts.pluck(:goodstype_id)} - #{g.goodstypes.pluck(:goodstype_id)} = #{gts.pluck(:goodstype_id) - g.goodstypes.pluck(:goodstype_id)}"
        new_gts = gts.pluck(:goodstype_id) - g.goodstypes.pluck(:goodstype_id)

        new_gts.each do |gt|
          g.goodstypes << Goodstype.find(gt)
        end
      end
    end
  end
end
