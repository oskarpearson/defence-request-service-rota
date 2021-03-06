class Rota
  attr_reader :rota_slots, :organisations, :locations

  def initialize(rota_slots, organisations, locations)
    @rota_slots = rota_slots
    @organisations = organisations
    @locations = locations
  end

  def to_partial_path
    "rotas/rota"
  end

  def date_range
    if !rota_slots.empty?
      (sorted_slots.first.starting_time.to_date..sorted_slots.last.starting_time.to_date)
    else
      []
    end
  end

  def on_duty(date, shift)
    organisations_and_solicitor_names(slots_on_duty(date, shift))
  end

  def procurement_area_name
    rota_slots.first.procurement_area.name if !rota_slots.empty?
  end

  def shifts
    sorted_shifts.map { |shift| ShiftPresenter.new(shift) }
  end

  def location_for_shift(shift)
    locations.detect { |l| l.uid == shift.location_uid }
  end

  def sorted_slots
    rota_slots.sort_by(&:starting_time)
  end

  def sorted_shifts
    rota_slots.map(&:shift).uniq.sort_by(&:name)
  end

  private

  def slots_on_duty(date, shift)
    rota_slots.select { |s| s.starting_time.to_date == date && s.shift_id == shift.id }
  end

  def organisations_and_solicitor_names(slots)
    slots.map do |s|
      organisation = organisations.detect { |o| o.uid == s.organisation_uid }
      {
        organisation_name: organisation.name,
        organisation_uid: organisation.uid,
        solicitor_name: s.solicitor_name
      }
    end
  end

end
