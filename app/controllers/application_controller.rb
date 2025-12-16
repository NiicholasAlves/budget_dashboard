class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges,
  # import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  # Require authentication by default
  before_action :authenticate_user!

  # Ensure Devise pages use the main application layout
  layout :layout_by_resource

  protected

  def layout_by_resource
    "application"
  end
end
