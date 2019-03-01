namespace :pg_move do

  task move: :environment do

    pr = ProjectGood.where(goods_priority_id: 3).all
    puts "pg.count #{pr.count}"
    pr.each do |p|
      p.goods_priority_id = 2
      p.save
    end
  end

end