class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record, vote = nil)
    @user = user || User::Guest.new
    @record = record
    @vote = vote
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    user?
  end

  def new?
    create?
  end

  def update?
    owner?
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end

  def api?
    user?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  private

  def owner?(object = record)
    user.author_of?(object)
  end

  protected

  def user?
    user.id > 0
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
