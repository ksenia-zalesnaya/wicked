module Wicked::Controller::Concerns::Steps
  PROTECTED_STEPS = [Wicked::FINISH_STEP, Wicked::FIRST_STEP, Wicked::LAST_STEP]

  extend ActiveSupport::Concern
  extend Wicked::Concerns::Steps

  def jump_to(goto_step, options = {})
    @skip_to                = goto_step
    @wicked_redirect_params = options
  end

  def skip_step(options = {})
    @skip_to                = @next_step
    @wicked_redirect_params = options
  end

  def step
    @step
  end

  module ClassMethods
    def steps(*args)
      steps   = args
      check_protected!(steps)
      prepend_before do
         self.steps = steps.dup
      end
    end

    def check_protected!(wizard_steps)
      string_steps = wizard_steps.map(&:to_s)
      if protected_step = PROTECTED_STEPS.detect { |protected| string_steps.include?(protected) }
        msg = "Protected step detected: '#{protected_step}' is used internally by Wicked please rename your step"
        raise WickedProtectedStepError, msg
      end
    end
  end

  def steps=(wizard_steps)
    @wizard_steps = wizard_steps
  end

  def steps
    @wizard_steps
  end
  alias :wizard_steps :steps
  alias :steps_list   :steps

  def previous_step(current_step = nil)
    return @previous_step if current_step.nil?
    index =  steps.index(current_step)
    step  =  steps.at(index - 1) if index.present? && index != 0
    step ||= steps.first
  end


  def next_step(current_step = nil)
    return @next_step if current_step.nil?
    index = steps.index(current_step)
    step  = steps.at(index + 1) if index.present?
    step  ||= Wicked::FINISH_STEP
  end
end
