# frozen_string_literal: true

class DocumentsController < ApplicationController
  def destroy
    document = ActiveStorage::Attachment.find_by(id: params[:id])
    if document
      authorize document

      document.purge_later
      flash[:success] = t('.deleted')
    else
      flash[:danger] = t('.not_found')
    end
    redirect_back(fallback_location: root_path)
  end
end
