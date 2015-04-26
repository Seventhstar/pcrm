class Develop < ActiveRecord::Base
  belongs_to :dev_project, foreign_key: :project_id
  def self.search(search)
    if search
      se = search.mb_chars.downcase
 	where('name LIKE ? ', "%#{se}%")
    else
      all
    end
  end

end
