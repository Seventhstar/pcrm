namespace :providers do

	task :p_status => :environment do

		pr = Provider.where.not(:p_status => 5).all
		pr.each do |p|
			#p p.p_status
			p.p_status_id = 2
			p.save
		end
	end

end