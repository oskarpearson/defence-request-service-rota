require_relative "../../lib/rota_generation"

class RotasController < ApiEnabledController
  def index
    @procurement_area = procurement_area
    @rota = Rota.new(rota_slots, organisations, locations)
  end

  def new
    @rota_generation_form = RotaGenerationForm.new(procurement_area)
  end

  def create
    assigned_rota_slots = RotaGeneration::Generator.new(
      allocated_rota_slots,
      member_uids
    ).generate_rota

    if assigned_rota_slots.map(&:save!)
      redirect_to procurement_area_rotas_path(procurement_area)
    end
  end

  private

  def procurement_area
    ProcurementArea.find(params[:procurement_area_id])
  end

  def allocated_rota_slots
    RotaSlotAllocator.new(
      date_range: build_date_range,
      shifts: shifts_for_location,
      procurement_area: procurement_area
    ).allocate
  end

  def build_date_range
    DateRange.new(params[:rota_generation_form]).build
  end

  def filter_date_range
    if params[:rota_filter].present?
      FilterRange.new(params[:rota_filter]).build
    else
      Range.new Time.now.beginning_of_month, Time.now.end_of_month
    end
  end

  def shifts_for_location
    procurement_area.locations.flat_map { |location| Shift.for(location["uid"]) }
  end

  def member_uids
    procurement_area.members.flat_map { |member| member["uid"] }
  end

  def locations
    all_organisations_by(uid: procurement_area.locations.flat_map { |location| location["uid"] })
  end

  def organisations
    all_organisations_by(uid: rota_slots.map(&:organisation_uid).uniq)
  end

  def rota_slots
    RotaSlot.for(procurement_area).where(starting_time: filter_date_range)
  end
end
