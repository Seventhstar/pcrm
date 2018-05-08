module Sortable
  extend ActiveSupport::Concern

  included do
    helper_method :sort_column, :sort_direction, :only_actual
    helper_method :sort_2, :dir_2
  end

  private
    def dir_2
      defaul_dir = sort_column =='status_date' ? "asc": "desc"
      %w[asc desc].include?(params[:dir2]) ? params[:dir2] : defaul_dir
    end

    def only_actual
      %w[true false nil].include?(params[:only_actual]) ? params[:only_actual] : "all"
    end
end