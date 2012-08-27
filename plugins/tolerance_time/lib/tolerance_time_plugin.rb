require_dependency 'ext/article'
require_dependency 'ext/comment'

class ToleranceTimePlugin < Noosfero::Plugin

  def self.plugin_name
    "Tolerance Time"
  end

  def self.plugin_description
    _("Adds a tolerance time for editing content after its publication")
  end

  def self.expired?(content)
    publication = ToleranceTimePlugin::Publication.find_by_target(content)
    (content.kind_of?(Comment) || (!content.folder? && content.published?)) &&
    ((!publication.present? && !content.profile.kind_of?(Person)) || (publication.present? && publication.expired?))
  end

  def control_panel_buttons
    {:title => _('Tolerance Adjustements'), :url => {:controller => 'tolerance_time_plugin_myprofile', :profile => context.profile.identifier}, :icon => 'tolerance-time'  }
  end

  def stylesheet?
    true
  end

  def cms_controller_filters
    return if !context.environment.plugin_enabled?(ToleranceTimePlugin)
    block = lambda do
      content = Article.find(params[:id])
      if ToleranceTimePlugin.expired?(content)
        session[:notice] = _('This content can\'t be edited anymore because it expired the tolerance time')
        redirect_to content.url
      end
    end

    { :type => 'before_filter',
      :method_name => 'expired_content',
      :options => {:only => 'edit'},
      :block => block }
  end

  def content_expire_edit(content)
    if ToleranceTimePlugin.expired?(content)
      _('The tolerance time for editing this content is over.')
    end
  end

end
