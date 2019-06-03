require "rails_helper"

RSpec.describe "users/show.html.erb", type: :view do
  let(:user) do
    User.create(
      name: Faker::Name.name,
      email: "user@example.com",
      phone: "012346578941",
      address: Faker::Name.name,
      password: "123456",
      password_confirmation: "123456")
  end

  before do
    assign :user, user
    render
  end

  context "should show user" do
    it {expect(rendered).to include user.name}
    it {expect(rendered).to include user.email}
    it {expect(rendered).to include user.address}
    it {expect(rendered).to include user.phone}
    it {expect(rendered).to include user.role}
    it {expect(rendered).to include "/users/#{user.id}/edit"}
  end
end
