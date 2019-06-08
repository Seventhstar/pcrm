module Commentable
  extend ActiveSupport::Concern

  private
    def create_first_comment(owner)
      prm = params[owner.class.name.downcase]
      if !prm[:first_comment]&.empty?
        user_id = prm[:user_id].nil? ? current_user.id : prm[:user_id]
        owner.comments.create({comment: prm[:first_comment], user_id: user_id})
      end
    end

    def dir_2
      defaul_dir = sort_column == 'status_date' ? "asc": "desc"
      %w[asc desc].include?(params[:dir2]) ? params[:dir2] : defaul_dir
    end

    def only_actual
      %w[true false nil].include?(params[:only_actual]) ? params[:only_actual] : "all"
    end
end