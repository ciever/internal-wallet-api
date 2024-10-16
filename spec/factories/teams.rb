FactoryBot.define do
  factory :team do
    name { "Test Team" }

    after(:create) do |team|
      create(:wallet, walletable: team)
    end
  end
end
