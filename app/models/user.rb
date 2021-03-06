class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_one :box

  validates :username, presence: true, format: { with: /\A[-a-z0-9_]+\Z/i, message: "is invalid. You can use letters (a-z), numbers (0-9), underscores (_) and dashes (-)." }, length: { maximum: 20, message: 'is too long. You can use up to 20 characters.'}

  # Setup accessible (or protected) attributes for your model
  # Move this to strong_params
  # attr_accessible :email, :password, :password_confirmation, :remember_me
end
