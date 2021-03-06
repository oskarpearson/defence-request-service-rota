require "spec_helper"
require "ostruct"
require_relative "../../../lib/rota_generation/allocator"

RSpec.describe RotaGeneration::Allocator do
  describe "#mutate_slots!" do
    it "updates the slots to contain the correct organisation UIDs" do
      slots = [
        OpenStruct.new(shift_id: 1, starting_time: Time.parse("01-01-2015 09:00"), organisation_uid: nil),
        OpenStruct.new(shift_id: 2, starting_time: Time.parse("01-01-2015 17:00"), organisation_uid: nil),
        OpenStruct.new(shift_id: 1, starting_time: Time.parse("02-01-2015 09:00"), organisation_uid: nil)
      ]

      solution_clauses = %w{
        allocated(1,thu,1,1,2015,"abc123").
        allocated(2,thu,1,1,2015,"jkl567").
        allocated(1,fri,2,1,2015,"xyz789").
        allocated(3,mon,5,1,2015,"abc123").
      }

      mutated_slots = RotaGeneration::Allocator.new(slots, solution_clauses).mutate_slots!

      expect(mutated_slots.map(&:organisation_uid)).
        to match(%w{abc123 jkl567 xyz789})
    end
  end
end
