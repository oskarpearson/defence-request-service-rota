class LocationShift
  def initialize(shift)
    @shift = shift
  end

  def id
    shift.id
  end

  def to_partial_path
    "location_shifts/location_shift"
  end

  def info
    "#{name} - #{starting_time} / #{ending_time}"
  end

  private

  attr_reader :shift

  def name
    if shift.name.empty?
      "N/A"
    else
      shift.name
    end
  end

  def starting_time
    shift.starting_time.to_formatted_s(:time)
  end

  def ending_time
    if shift.ending_time
      shift.ending_time.to_formatted_s(:time)
    else
      "until release"
    end
  end
end