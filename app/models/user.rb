class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :item_results

  def self.create_anonymous
    user = User.new
    user.email                 = "#{::SecureRandom::hex(8)}@example.com"
    user.password              = ::SecureRandom::hex(8)
    user.password_confirmation = user.password
    user.save!
    user
  end

end
