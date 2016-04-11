module Spree
  class ExperienceDropShipConfiguration < Preferences::Configuration

    # Determines whether or not to email a new experience their welcome email.
    preference :send_experience_email, :boolean, default: true

  end
end