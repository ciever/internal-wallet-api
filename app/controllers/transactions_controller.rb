class TransactionsController < ApplicationController
  before_action :authenticate_user!, only: [:create] 

  def create
    transaction_params = params.require(:transaction).permit(:amount, source: {}, target: {})

    unless valid_wallet_info?(transaction_params[:source]) && valid_wallet_info?(transaction_params[:target])
      render json: { status: 'error', message: 'Invalid wallet information' }, status: :unprocessable_entity and return
    end

    source_info = transaction_params[:source]
    target_info = transaction_params[:target]

    target_wallet = find_wallet(target_info)
    source_wallet = find_wallet(source_info) unless source_info.nil?

    service = Services::TransactionService.new(source_wallet, target_wallet, transaction_params[:amount])

    if service.call
      render json: { status: 'success', transaction: service.transaction }, status: :created
    else
      render json: { status: 'error', message: 'Transaction failed' }, status: :unprocessable_entity
    end
  end

  private

  def valid_wallet_info?(wallet_info)
    wallet_info && wallet_info[:type].in?(%w[User Team Stock]) && wallet_info[:id].present?
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
      raise ActiveRecord::RecordNotFound, "Wallet not found"
    end
  end
end
