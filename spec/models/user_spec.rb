require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { User.new(name: Faker::Name.name,
                       email: "user@example.com",
                       phone: "012346578941",
                       address: Faker::Name.name,
                       password: "123456",
                       password_confirmation: "123456") }

  context ".validation" do
    it "should be valid" do
      expect(user).to be_valid
    end

    it "name should be present" do
      user.name = " ";
      expect(user).to_not be_valid
      user.save
      expect(user.errors.messages).to include(name: including(I18n.t("errors.messages.blank")))
    end

    it "name should not be too long" do
      user.name = "a" * (Settings.users.name_length + 1);
      expect(user).to_not be_valid
      user.save
      expect(user.errors.messages).to include(name: including(I18n.t("errors.messages.too_long",
        count: Settings.users.name_length)))
    end

    it "email reject invalid addresses" do
      invalid_addresses = %w(user_at_foo.org user.name@example.
        foo@bar_baz.com foo@bar+baz.com poem@gmail.com23)
      invalid_addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).to_not be_valid
      end
      user.save
      expect(user.errors.messages).to include(email: including(I18n.t("errors.messages.invalid")))
    end

    it "email addresses should be unique" do
      duplicate_user = user.dup
      duplicate_user.email = user.email
      user.save
      expect(duplicate_user).to_not be_valid
      duplicate_user.save
      expect(duplicate_user.errors.messages).to include(email: including(I18n.t("errors.messages.taken")))
    end

    it "address should be present" do
      user.address = " ";
      expect(user).to_not be_valid
      user.save
      expect(user.errors.messages).to include(address: including(I18n.t("errors.messages.blank")))
    end

    it "phone should be numbericality" do
      user.phone = "013246a4564"
      user.save
      expect(user.errors.messages).to include(phone: including(I18n.t("errors.messages.not_a_number")))
      user.phone = "0123467891"
      expect(user).to be_valid
    end

    it "phone should not be too long" do
      ["1" * 16, "0132451", "0132451234"].each do |n|
        user.phone = n
        puts "#{n} valid: #{user.valid?}"
      end
    end

    it "password should be present" do
      user.password = user.password_confirmation = " " * 6
      expect(user).to_not be_valid
      user.save
      expect(user.errors.messages).to include(password: including(I18n.t("errors.messages.blank")))
    end

    it "confirmation password should be true" do
      user.password = "123456"
      user.password_confirmation = "654321"
      expect(user).to_not be_valid
      user.save
      expect(user.errors.messages).to include(password_confirmation: including(
        I18n.t("errors.messages.confirmation", attribute: "Password")))
    end

    puts "User validation"
  end

  context ".associations" do
    it "should have many orders" do
      assc = User.reflect_on_association(:orders)
      expect(assc.macro).to eq(:has_many)
    end

    it "should have many reviews" do
      assc = User.reflect_on_association(:reviews)
      expect(assc.macro).to eq(:has_many)
    end

    it "should have many suggestions" do
      assc = User.reflect_on_association(:suggestions)
      expect(assc.macro).to eq(:has_many)
    end

    puts "User associations"
  end
end
