class MezuroPluginMyprofileController < ProfileController #MyprofileController?

 before_filter :verify_ownership

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
      redirect_to_error_page "You are not authorized to access this page."
    end
  end

  def is_owner?
    raise params.inspect
    unless user.nil?
      profile_id = profile.articles.find(params[:id]).profile_id
      owner_id = Profile.find(profile_id).user_id
      owner_id == user.id
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
