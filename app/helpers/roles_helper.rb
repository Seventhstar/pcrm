module RolesHelper
  def is_admin?
    current_user.admin?
  end

  def is_author_of?(obj)
    current_user.author_of?(obj)
  end

  def is_manager?
    current_user.has_role?(:manager)
  end
end
