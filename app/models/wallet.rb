class Wallet < ApplicationRecord
  belongs_to :walletable, polymorphic: true
  has_many :outgoing_transactions, class_name: 'Transaction', foreign_key: :source_wallet_id, dependent: :destroy
  has_many :incoming_transactions, class_name: 'Transaction', foreign_key: :target_wallet_id, dependent: :destroy

  def balance
    incoming_transactions.sum(:amount) - outgoing_transactions.sum(:amount)
  end
end
