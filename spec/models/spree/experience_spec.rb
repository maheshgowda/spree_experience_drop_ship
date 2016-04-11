require 'spec_helper'

describe Spree::Experience do

  it { should belong_to(:address) }

  it { should have_many(:products).through(:variants) }
  it { should have_many(:users) }
  it { should have_many(:variants).through(:experience_variants) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }

  it '#deleted?' do
    subject.deleted_at = nil
    subject.deleted_at?.should eql(false)
    subject.deleted_at = Time.now
    subject.deleted_at?.should eql(true)
  end

  context '#assign_user' do

    before do
      @instance = build(:experience)
    end

    it 'with user' do
      Spree.user_class.should_not_receive :find_by_email
      @instance.email = 'test@test.com'
      @instance.users << create(:user)
      @instance.save
    end

    it 'with existing user email' do
      user = create(:user, email: 'test@test.com')
      Spree.user_class.should_receive(:find_by_email).with(user.email).and_return(user)
      @instance.email = user.email
      @instance.save
      @instance.reload.users.first.should eql(user)
    end

  end


  context '#send_welcome' do

    after do
      SpreeExperienceDropShip::Config[:send_experience_email] = true
    end

    before do
      @instance = build(:experience)
      @mail_message = double('Mail::Message')
    end

    context 'with Spree::ExperienceDropShipConfig[:send_experience_email] == false' do

      it 'should not send' do
        SpreeExperienceDropShip::Config[:send_experience_email] = false
        expect {
          Spree::ExperienceMailer.should_not_receive(:welcome).with(an_instance_of(Integer))
        }
        @instance.save
      end

    end

    context 'with Spree::ExperienceDropShipConfig[:send_experience_email] == true' do

      it 'should send welcome email' do
        expect {
          Spree::ExperienceMailer.should_receive(:welcome).with(an_instance_of(Integer))
        }
        @instance.save
      end

    end

  end


end