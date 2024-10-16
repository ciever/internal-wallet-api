FactoryBot.define do
  factory :stock do
    company_name { "Test stock" }

    after(:create) do |stock|
      create(:wallet, walletable: stock)
    end
  end
end
