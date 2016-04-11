class Spree::Experience < Spree::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  attr_accessor :password, :password_confirmation

  #==========================================
  # Associations

  belongs_to :address, class_name: 'Spree::Address'
  accepts_nested_attributes_for :address

  if defined?(Ckeditor::Asset)
    has_many :ckeditor_pictures
    has_many :ckeditor_attachment_files
  end
  has_many   :products, through: :variants
  has_many   :experience_variants
  has_many   :users, class_name: Spree.user_class.to_s
  has_many   :variants, through: :experience_variants

  #==========================================
  # Validations

  validates :email,                  presence: true, email: true, uniqueness: true
  validates :name,                   presence: true, uniqueness: true
  validates :url,                    format: { with: URI::regexp(%w(http https)), allow_blank: true }

  #==========================================
  # Callbacks

  after_create :assign_user
  after_create :send_welcome, if: -> { SpreeExperienceDropShip::Config[:send_experience_email] }
  before_validation :check_url

  #==========================================
  # Instance Methods
  scope :active, -> { where(active: true) }

  def deleted?
    deleted_at.present?
  end

  def user_ids_string
    user_ids.join(',')
  end

  def user_ids_string=(s)
    self.user_ids = s.to_s.split(',').map(&:strip)
  end

  # Retreive the stock locations that has available
  # stock items of the given variant
  #==========================================
  # Protected Methods

  protected

    def assign_user
      if self.users.empty?
        if user = Spree.user_class.find_by_email(self.email)
          self.users << user
          self.save
        end
      end
    end

    def check_url
      unless self.url.blank? or self.url =~ URI::regexp(%w(http https))
        self.url = "http://#{self.url}"
      end
    end

    
    def send_welcome
      begin
        Spree::ExperienceMailer.welcome(self.id).deliver_later!
        # Specs raise error for not being able to set default_url_options[:host]
      rescue => ex #Errno::ECONNREFUSED => ex
        Rails.logger.error ex.message
        Rails.logger.error ex.backtrace.join("\n")
        return true # always return true so that failed email doesn't crash app.
      end
    end

end