module Spree
  Variant.class_eval do

    has_many :experiences, through: :experience_variants
    has_many :experience_variants

    before_create :populate_for_experiences

    private

    def populate_for_experiences
      self.experiences = self.product.experiences
    end

  end
end