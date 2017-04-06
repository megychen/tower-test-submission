module ProjectsHelper
  def check_project_owner(member, project)
    if current_user && member.user_id == project.user_id
      content_tag(:sapn, "超级管理员", :class => "label label-warning")
    end
  end

  def check_project_permission(project)
    if project.user == current_user
      true
    else
      false
    end
  end
end
