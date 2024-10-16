# Internal Wallet Api

This is an API only app built in Ruby on Rails.

**Note:** this app was built on `ruby 3.0.1` and `rails 7.1.4`

## Getting Started

1. Clone the repository locally.
2. Navigate to the project directory.
3. From terminal or any command line, run the migration: 
```
rails db:migrate
```
4. Create all the data by running:
```
rails db:seed 
```

After running the seed.rb file, the following records should exist:

```ruby
# The Rails console should return:
User.count # 3
Stock.count # 3
Team.count # 3
```

Each of the entities (User, Stock and Team) should have a wallet with an initial balance of 1000.00

```ruby
# The Rails console should return:
user_wallet = user.first.wallet
user.balance # 1000.00

stock_wallet = stock.second.wallet
stock.balance # 1000.00

team_wallet = team.second.wallet
team.balance # 1000.00
```
5. Run the rails server in terminal (or similar) in the local project directory: 

```
rails s
```

Note the server address and port to interact with the app. Example - `Listening on http://127.0.0.1:3000`

## Interacting With The App

### Step 1 - Sign in

Before being able to make any transactions, the user must be signed in.

Make a `POST` request to `http://127.0.0.1:3000/sign_in`

```
# Headers
Content-Type = application/json

# Body
{
  "email": use_rails_console_to_find_any_user_email,
  "password": "password"
}
```

To get the email of a user, simply use the Rails console:

```ruby
User.first.email # example - "user_300248@wallet.com.au"
```

The password will always be "password" for all pre-existing users (as per seed.rb)

After the sign in is successful, the following response should be returned from the post request:
```
{
    "message": "Signed in successfully."
}
```

**Note** If you need to sign out, make a `DELETE` request to `http://127.0.0.1:3000/sign_out`. No body or header is requried. 

### Step 2 - Transfer Funds

#### Example 1 - Transfering funds between entities (from a user to a team).

Make a `POST` request to `http://127.0.0.1:3000/transactions`.

The request body should look something like this
```
{
  "transaction": {
    "source": {
        "type": "User",
        "id": 1  // ID of the user to whom you are transferring funds to (find user id in Rails console)
    },
    "target": {
      "type": "Team",
      "id": 1  // ID of the team to whom you are transferring funds to (find team id in Rails console)
    },
    "amount": 10.99  // Amount to deposit
  }
}
```


#### Example 2 - Transfering funds from an external source to an entitiy like a user.

Make a `POST` request to `http://127.0.0.1:3000/transactions`.

The request body should look something like this
```
{
  "transaction": {
    "source": null,
    "target": {
      "type": "Team",
      "id": 1  // ID of the user to whom you are transferring funds to (find user id in Rails console)
    },
    "amount": 10.99  // Amount to deposit
  }
}
```

## Specs

This app uses `rspec`.

To run all the tests simply run the following in the project directory:

```
rspec
```

All the models, service objects, controllers have specs.

## Gems

This app uses no gems to make the internal wallet API function. 

Information about the LatestStockPrice Gem will be available soon. 

