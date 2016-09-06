module Wicked::Concerns::Steps
  extend ActiveSupport::Concern

  # will return true if step passed in is the currently rendered step
  def current_step?(step_name)
    return false unless current_and_given_step_exists?(step_name)
    step.to_sym == step_name.to_sym
  end

  # will return true if the step passed in has already been executed by the wizard
  def past_step?(step_name)
    return false unless current_and_given_step_exists?(step_name)
    current_step_index > step_index_for(step_name)
  end

  # will return true if the step passed in has not been executed by the wizard
  def future_step?(step_name)
    return false unless current_and_given_step_exists?(step_name)
    current_step_index < step_index_for(step_name)
  end

  # will return true if the last step is the step passed in
  def previous_step?(step_name)
    return false unless current_and_given_step_exists?(step_name)
    (current_step_index - 1)  == step_index_for(step_name)
  end

  # will return true if the next step is the step passed in
  def next_step?(step_name)
    return false unless current_and_given_step_exists?(step_name)
    (current_step_index + 1)  == step_index_for(step_name)
  end

  def step_index_for(step_name)
    steps.index(step_name.to_sym)
  end

  private

  def current_step_index
    step_index_for(step)
  end

  def current_and_given_step_exists?(step_name)
    current_step_index.present? && steps.index(step_name).present?
  end
end
