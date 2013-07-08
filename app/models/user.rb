class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  has_many :assessment_results
  has_many :item_results

  before_save :ensure_authentication_token

  def display_name
  end

  def self.create_anonymous
    user = User.new
    user.email                 = "#{::SecureRandom::hex(8)}@example.com"
    user.password              = ::SecureRandom::hex(8)
    user.password_confirmation = user.password
    user.save!
    user
  end

end
