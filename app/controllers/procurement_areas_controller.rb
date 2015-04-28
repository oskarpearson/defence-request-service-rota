class ProcurementAreasController < ApplicationController
  def index
    @procurement_areas = ProcurementArea.ordered_by_name
  end

  def new
    @procurement_area = ProcurementArea.new
  end

  def create
    procurement_area = ProcurementArea.new(procurement_area_params)

    if procurement_area.save
      redirect_to procurement_areas_path
    end
  end

  def edit
    @procurement_area = procurement_area
  end

  def update
    if procurement_area.update_attributes(procurement_area_params)
      redirect_to procurement_areas_path
    end
  end

  def destroy
    if procurement_area.destroy
      redirect_to procurement_areas_path
    end
  end

  private

  def procurement_area_params
    params.require(:procurement_area).permit(:name)
  end

  def procurement_area
    @_procurement_area ||= ProcurementArea.find(params[:id])
  end
end
