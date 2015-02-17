class Develop < ActiveRecord::Base
def self.search(search)
    if search
      se = search.mb_chars.downcase
 	where('name LIKE ? ', "%#{se}%")
    else
      all
    end
  end

end
