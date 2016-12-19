class Form < ActiveRecord::Base
  attr_accessible :name, :redirect, :webhook, :user_id, :email, :disallow_urls

  belongs_to :user
  has_many :submissions, dependent: :destroy

  validates :user, presence: true
  validates :name, presence: true
  validates :token, presence: true
  validates :honeypot, presence: true
  validates :redirect, presence: true,
                       format: { with: URI.regexp(%w(http https)) }
  validates :email, email: true, allow_blank: true
  validates :webhook, format: { with: URI.regexp(%w(http https)),
                                allow_blank: true }

  before_validation :generate_token, if: "token.blank?"
  before_validation :generate_honeypot, if: "honeypot.blank?"

  def to_param
    token
  end

  private

  def generate_token
    self.token = loop do
      random_token = Form.random_string(15)
      break random_token unless Form.exists?(token: random_token)
    end
  end

  def generate_honeypot
    self.honeypot = Form.random_string(15)
  end

  def self.random_string(length)
    alphanumerics = [("0".."9"), ("a".."z")].map(&:to_a).flatten
    (0...length).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
  end
end
