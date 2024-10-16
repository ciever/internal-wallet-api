# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Users
3.times do
  random_string = SecureRandom.hex(3) 

  user = User.find_or_create_by!(
    email: "user_#{random_string}@wallet.com.au"
  ) do |u|
    u.name = "User_#{random_string}"
		u.password = "password"
  end
	
	user_wallet = Wallet.find_or_create_by!(walletable: user)
	# Add funds to user
	service = Services::TransactionService.new(nil, user_wallet, 1000)
	service.call
end
  
# Create Stocks
3.times do
	random_string = SecureRandom.hex(3) 

	stock = Stock.find_or_create_by!(company_name: "company#{random_string}")
	stock_wallet = Wallet.find_or_create_by!(walletable: stock)
	# Add funds to stock
	service = Services::TransactionService.new(nil, stock_wallet, 1000)
	service.call
end
  
# Create Teams
3.times do
	random_string = SecureRandom.hex(3)

	team = Team.find_or_create_by!(name: "Team#{random_string}")
	team_wallet = Wallet.find_or_create_by!(walletable: team)
	# Add funds to team
	service = Services::TransactionService.new(nil, team_wallet, 1000)
	service.call
end