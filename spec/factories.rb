FactoryGirl.define do
  factory :admin_user, class: Omniauth::Dsds::User do
    roles ["admin"]

    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example User",
        email: "user@example.com",
        roles: roles,
        organisation_uids: []
      )
    }
  end

  factory :procurement_area do
    name "Outlands"

    trait :with_members do
      memberships { [] }
    end

    trait :with_locations do
      locations { [] }
    end
  end
end