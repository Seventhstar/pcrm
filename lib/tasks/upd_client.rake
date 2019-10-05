namespace :upd_client do

  task ch_city: :environment do
    # c1 = Client.where(id: Project.where(city_id: 2).pluck(:client_id))
    c1 = Project.where(city_id: 2).pluck(:client_id)
    c1.each do |c|
      cl = Client.find(c)
      cl.update_attribute(:city_id, 2)
    end
    # puts "Мск: #{c1}"
    # c2 = Project.where(city_id: 1).pluck(:client_id)
    # puts "Мск: #{c1&c2}"

  end

end
