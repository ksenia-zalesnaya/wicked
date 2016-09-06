module Wicked::Controller::Concerns::Path
  extend ActiveSupport::Concern


  def next_wizard_path(options = {})
    wizard_path(next_step, options)
  end

  def previous_wizard_path(options = {})
    wizard_path(previous_step, options)
  end

  def wicked_controller
    params[:controller]
  end

  def wicked_action
    params[:action]
  end


  def wizard_path(goto_step = nil, options = {})
    options = options.respond_to?(:to_h) ? options.to_h : options
    options = options.deep_merge(params.to_h).merge(id: goto_step || params[:id])
    route_for(wicked_controller, options)
  end
end
