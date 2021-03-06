FactoryGirl.define do
  factory :admin_user, class: Omniauth::Dsds::User do
    to_create { |instance| instance }

    initialize_with {
      new(
        uid: SecureRandom.uuid,
        name: "Example User",
        email: "user@example.com",
        organisations: [
          {
            "uid" => SecureRandom.uuid,
            "name" => "LAA Rota Team",
            "type" => "laa_rota_team",
            "roles" => ["rotaTeam"]
          }
        ]
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

  factory :rota_slot do
    starting_time { Time.now }
    shift
    organisation_uid { SecureRandom.uuid }
    procurement_area
  end

  factory :shift do
    location_uid { SecureRandom.uuid }
    starting_time { Time.parse("2014-01-01 00:00") }
    allocation_requirements_per_weekday {
      Shift::WEEKDAYS.inject({}) do |result, key|
        result[key] = 0
        result
      end
    }
  end
end
