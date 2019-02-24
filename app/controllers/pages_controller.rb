class PagesController < ApplicationController
  before_action :verify_page, only: [:show]

  def index
  end

  private

  def verify_page
    render_not_found unless ENUMS::PAGES.values.any?(params[:id])
  end
end
