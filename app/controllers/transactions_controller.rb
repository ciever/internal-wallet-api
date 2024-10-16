class TransactionsController < ApplicationController
  before_action :authenticate_user!, only: [:create] 

  def create
    transaction_params = params.require(:transaction).permit(:amount, source: {}, target: {})

    source_info = transaction_params[:source]
    target_info = transaction_params[:target]

    if invalid_wallet_type?(source_info) || invalid_wallet_type?(target_info)
      render json: { status: 'error', message: 'Invalid wallet type' }, status: :unprocessable_entity and return
    end

    source_wallet = find_wallet(source_info) unless source_info.nil?
    target_wallet = find_wallet(target_info)

    service = Services::TransactionService.new(source_wallet, target_wallet, transaction_params[:amount])

    if service.call
      render json: { status: 'success', transaction: service.transaction }, status: :created
    else
      render json: { status: 'error', message: 'Transaction failed' }, status: :unprocessable_entity
    end
  end

  private

  def invalid_wallet_type?(wallet_info)
    return false if wallet_info.nil?
  
    !%w[User Team Stock].include?(wallet_info[:type])
  end
  
  def find_wallet(wallet_info)
    case wallet_info[:type]
    when 'User'
      User.find(wallet_info[:id]).wallet
    when 'Team'
      Team.find(wallet_info[:id]).wallet
    when 'Stock'
      Stock.find(wallet_info[:id]).wallet
    else
      nil
    end
  end
end
