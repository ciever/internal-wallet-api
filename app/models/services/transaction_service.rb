class Services::TransactionService
  attr_reader :transaction

  def initialize(source_wallet, target_wallet, amount)
    @source_wallet = source_wallet
    @target_wallet = target_wallet
    @amount = parse_amount(amount)
    @transaction = nil
  end

  def call
    ActiveRecord::Base.transaction do
      if source_wallet.nil?  # If external transaction
        create_transaction(nil)
      else
        validate_balance
        create_transaction(source_wallet)
      end
    end
  end

  private

  attr_reader :source_wallet, :target_wallet, :amount

  def parse_amount(amount)
    BigDecimal(amount.to_s)
  rescue ArgumentError
    raise StandardError, "Invalid amount: #{amount}"
  end
  
  def validate_balance
    raise StandardError, 'Insufficient funds in the source wallet.' if source_wallet.balance < amount
  end

  def create_transaction(source_wallet)
    @transaction = Transaction.create!(
      source_wallet: source_wallet,
      target_wallet: target_wallet,
      amount: amount
    )
  end
end
