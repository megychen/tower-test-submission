module TeamsHelper
  def check_team_owner(member, team)
    if current_user && member.user_id == team.user_id
      content_tag(:sapn, "超级管理员", :class => "label label-warning")
    end
  end

  def check_team_permission(team)
    if team.user == current_user
      true
    else
      false
    end
  end
end
