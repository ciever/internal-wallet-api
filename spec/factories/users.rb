FactoryBot.define do
  factory :user do
		name { "test" }
    email { "test@test.com" }
    password { "password" }

		after(:create) do |user|
      create(:wallet, walletable: user)
    end
  end
end
