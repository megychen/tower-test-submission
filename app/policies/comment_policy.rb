class CommentPolicy < ApplicationPolicy
  def destroy?
    record.user == user || record.user_id == record.team.user_id
  end
end
