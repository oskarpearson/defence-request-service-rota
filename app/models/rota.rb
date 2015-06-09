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

  def procurement_area_name
    rota_slots.first.procurement_area.name if !rota_slots.empty?
  end

  def shifts
    sorted_shifts.map { |shift| ShiftPresenter.new(shift) }
  end

  def location_for_shift(shift)
    locations.detect { |l| l.uid == shift.location_uid }
  end

  def grouped_slots_by_date
    sorted_slots.group_by(&:date)
  end

  def sorted_slots
    rota_slots.sort_by(&:date)
  end

  def sorted_shifts
    rota_slots.map(&:shift).uniq.sort_by(&:name)
  end
end