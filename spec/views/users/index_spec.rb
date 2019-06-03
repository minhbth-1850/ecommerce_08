require "rails_helper"

RSpec.describe "users/index.html.erb", type: :view do
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
    allow(view).to receive_messages(will_paginate: nil)
    assign :users, [user]
    render
  end

  context "should index users" do
    it "display header user" do
      expect(rendered).to include "<h1>#{I18n.t("label.user")}</h1>"
    end

    it {expect(rendered).to have_select "sort_id"}
    it {expect(subject).to render_template(partial: "_user")}

    # Test view data of item user
    it {expect(rendered).to include user.name}
    it {expect(rendered).to include user.email}
    it {expect(rendered).to include user.address}
    it {expect(rendered).to include user.phone}
    it {expect(rendered).to include user.role}
    it {expect(rendered).to include "/users/#{user.id}/edit"}
    it {expect(rendered).to include "/users/#{user.id}"}
  end
end
