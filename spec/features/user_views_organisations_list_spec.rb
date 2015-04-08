require "rails_helper"

RSpec.feature "User views a list of organisations" do
  def sign_in_using_dsds_auth
    visit root_path
  end

  scenario "on their dashboard" do
    expected_organisation_names = "Tuckers", "Brighton"

    mock_token
    mock_profile

    sign_in_using_dsds_auth

    expect(page).to have_css "h2", text: "Organisations"
    expect(page).to have_css "h3", text: "Tuckers (law_firm)"
    expect(page).to have_css "h3", text: "Brighton (custody_suite)"
  end
end