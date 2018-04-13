class DocumentsController < ApplicationController
  def destroy
    document = ActiveStorage::Attachment.find_by(id: params[:id])
    if document
      document.purge
      flash[:success] = 'Removed'
    else
      flash[:success] = 'File not found'
    end
    redirect_back(fallback_location: root_path)
  end
end