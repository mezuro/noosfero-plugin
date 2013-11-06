require 'yaml'

Savon.configure do |config|
  config.log = HTTPI.log = (RAILS_ENV == 'development')
end

class MezuroPlugin < Noosfero::Plugin

  def self.plugin_name
    "Mezuro"
  end

  def self.plugin_description
    _("A metric analizer plugin.")
  end

  def stylesheet?
    true
  end

  def content_types
    if context.profile.is_a?(Community)
      MezuroPlugin::ProjectContent
    else
      [MezuroPlugin::ConfigurationContent,
      MezuroPlugin::ReadingGroupContent]
    end
  end

  def control_panel_buttons
    if context.profile.is_a?(Community)
      make_button('Mezuro project', 'MezuroPlugin::ProjectContent')
    else
      [make_button('Mezuro configuration', 'MezuroPlugin::ConfigurationContent'),
       make_button('Mezuro reading group', 'MezuroPlugin::ReadingGroupContent')]
    end
  end

  private

  def make_button(title, type)
    {:title => _(title), :url => {:controller =>  'cms', :action => 'new', :profile => context.profile.identifier, :type => type}, :icon => 'mezuro' }
  end


end
