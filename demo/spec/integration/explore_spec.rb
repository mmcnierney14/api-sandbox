require 'spec_helper'

describe "API Explorer", :js => true, :type => :request do
  context "page" do
    before :each do
      visit "/explore.html"
    end
    it "displays API explorer" do
      page.find("title").text.should == "API Explorer"
    end
    it "executes default API route" do
      rang = Acme::API_v1.class_variable_get(:@@rang)
      page.find("#response").should have_content "{\n\t\"rang\":#{rang}\n}"
    end
  end
end

