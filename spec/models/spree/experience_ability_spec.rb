require 'spec_helper'
require 'cancan/matchers'
require 'spree/testing_support/ability_helpers'

describe Spree::ExperienceAbility do

  let(:user) { create(:user, experience: create(:experience)) }
  let(:ability) { Spree::ExperienceAbility.new(user) }
  let(:token) { nil }

  context 'for Dash' do
    let(:resource) { Spree::Admin::RootController }

    context 'requested by experience' do
      it_should_behave_like 'access denied'
      it_should_behave_like 'no index allowed'
      it_should_behave_like 'admin denied'
    end
  end

  context 'for Product' do
    let(:resource) { create(:product) }

    it_should_behave_like 'index allowed'
    it_should_behave_like 'admin granted'

    context 'requested by another experiences user' do
      let(:resource) {
        product = create(:product)
        product.add_experience!(create(:experience))
        product
      }
      it_should_behave_like 'access denied'
    end

    context 'requested by experiences user' do
      let(:resource) {
        product = create(:product)
        product.add_experience!(user.experience)
        product.reload
      }
      # it_should_behave_like 'access granted'
      it { ability.should be_able_to :read, resource }
      it { ability.should be_able_to :stock, resource }
    end
  end


 
  context 'for Experience' do
    context 'requested by any user' do
      let(:ability) { Spree::ExperienceAbility.new(create(:user)) }
      let(:resource) { Spree::Experience }

      it_should_behave_like 'admin denied'
      it_should_behave_like 'access denied'
    end

    context 'requested by experiences user' do
      let(:resource) { user.experience }
      it_should_behave_like 'admin granted'
      it_should_behave_like 'update only'
    end
  end

end