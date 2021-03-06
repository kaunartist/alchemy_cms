require 'spec_helper'

describe "Translation integration" do

  context "in admin backend" do

    before do
      authorize_as_admin
    end

    it "should be possible to set the locale of the admin backend via params" do
      visit admin_dashboard_path(:locale => :de)
      page.should have_content('Willkommen')
    end

    it "should store the current locale in the session" do
      visit admin_dashboard_path(:locale => :de)
      visit admin_dashboard_path
      page.should have_content('Willkommen')
    end

    it "should be possible to change the current locale in the session" do
      visit admin_dashboard_path(:locale => :de)
      page.should have_content('Willkommen')
      visit admin_dashboard_path(:locale => :en)
      page.should have_content('Welcome')
    end

    it "should not be possible to switch the locale of the admin backend to an unknown locale" do
      visit admin_dashboard_path(:locale => :ko)
      page.should have_content('Welcome')
    end

    context "if no other parameter is given" do
      it "should use the current users language setting" do
        Alchemy::User.first.update_attributes!(language: 'de')
        visit admin_dashboard_path
        page.should have_content('Willkommen')
      end
    end

  end

  context "with translated header" do

    before do
      Capybara.current_driver = :rack_test_translated_header
    end

    it "should use the browsers language setting if no other parameter is given" do
      visit root_path
      ::I18n.locale.should == :de
    end

  end

end
