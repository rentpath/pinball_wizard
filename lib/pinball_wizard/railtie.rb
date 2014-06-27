require 'pinball_wizard/view_helpers/rails'

module PinballWizard
  class Railtie < Rails::Railtie
    initializer "pinball_wizard.action_view.add_pinball_helpers" do
      ActionView::Base.send :include, PinballWizard::ViewHelpers::Rails
    end
  end
end
