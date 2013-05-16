class MezuroPluginMyprofileController < ProfileController #MyprofileController?

  before_filter :verify_ownership, :except => [:error_page]

  append_view_path File.join(File.dirname(__FILE__) + '/../../views')

#  rescue_from Exception do |exception|
#    @message = process_error_message exception.message
#    render :partial => "error_page"
#  end

  def error_page
    @message = params[:message]
  end

  protected

  def verify_ownership
    unless is_owner?
      redirect_to_error_page "You are not authorized to access this page"
    end
  end

  def is_owner?
    unless user.nil?
      owner_id = profile.user_id
      user_id = user.user_id
      owner_id == user_id
    else
      false
    end
  end

  def redirect_to_error_page(message)
    message = URI.escape(CGI.escape(process_error_message(message)),'.')
    redirect_to "/myprofile/#{profile.identifier}/plugin/mezuro/error_page?message=#{message}"
  end

  def process_error_message message #FIXME
    if message =~ /bla/
      message
    else
      message
    end
  end

end
