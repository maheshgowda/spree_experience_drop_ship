module Spree
  class ExperienceAbility
    include CanCan::Ability

    def initialize(user)
      user ||= Spree.user_class.new

      if user.experience
        # TODO: Want this to be inline like:
        # can [:admin, :read, :stock], Spree::Product, experiences: { id: user.experience_id }
        # can [:admin, :read, :stock], Spree::Product, experience_ids: user.experience_id
        can [:admin, :read], Spree::Product do |product|
          product.experience_ids.include?(user.experience_id)
        end
        can [:admin, :index], Spree::Product
        can [:admin, :update], Spree::Experience, id: user.experience_id
      end

    end
  end
end