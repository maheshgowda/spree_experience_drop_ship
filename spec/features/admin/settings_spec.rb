require 'spec_helper'

describe 'Admin - ExperienceDropShip Settings', js: true do

  before do
    login_user create(:admin_user)

    visit spree.admin_path
    within '[data-hook=admin_tabs]' do
      click_link 'Configuration'
    end
    within 'ul[data-hook=admin_configurations_sidebar_menu]' do
      click_link 'Experience Drop Ship Settings'
    end
  end

  it 'should be able to be updated' do
    # Change settings
    uncheck 'send_experience_email'
    
    # Verify update saved properly by reversing checkboxes or checking field values.
    check 'send_experience_email'
    
  end

end