
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  
class ClientPolicy < ApplicationPolicy
  def index?
    true  # All signed-in users can list their clients
  end

  def show?
    user_owns_record?
  end

  def create?
    true  # All signed-in users can create
  end

  def update?
    user_owns_record?
  end

  def destroy?
    user_owns_record?
  end

  private

  def user_owns_record?
    user == record.user
  end
end
