class User < ApplicationRecord
  has_secure_password

  has_one :wallet, as: :walletable, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
end
