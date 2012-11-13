require 'spec_helper'

describe "Grape on RACK", :js => true, :type => :request do
  context "homepage" do
    before :each do
      visit "/"
    end
    it "displays index.html page" do
      page.find("title").text.should == "Rack Powers Web APIs"
    end
  end
end

