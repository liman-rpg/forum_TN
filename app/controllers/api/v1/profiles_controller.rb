class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize current_resource_owner, :api?
    respond_with current_resource_owner
  end

  def index
    authorize User.new, :api?
    respond_with User.where.not(id: current_resource_owner.id)
  end
end
