class AttachmentsController < ApplicationController
  before_action :authenticate_user!, only: :destroy

  def destroy
    @attachment = Attachment.find(params[:id])

    if current_user.author_of?(@attachment.attachable)
      @attachment.destroy
      flash.now[:notice] = "Your attachment was successfully destroy."
    else
      flash.now[:notice] = "You can't delete that attachment"
    end
  end
end
