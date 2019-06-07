require "rails_helper"

RSpec.describe "users/new.html.erb", type: :view do
  before do
    assign(:user, User.new)
    render
  end

  context "should form user" do
    it {expect(subject).to render_template(partial: "_form")}
  end
end
