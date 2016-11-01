class MatchPolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where("user_id = #{user.id} OR matched_user_id = #{user.id}")
    end
  end
end
