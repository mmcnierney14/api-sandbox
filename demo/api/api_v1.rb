module Acme
  class API_v1 < Grape::API
    @@rang = 0
    version 'v1', :using => :path, :vendor => 'acme', :format => :json
    desc "Returns number of rings."
    get :ring do
      { :rang => @@rang }
    end
    desc "Rings the bell."
    post :ring do
      @@rang += 1
      { :rang => @@rang }
    end
    desc "Rings the bell.",
      :params => { "count" => { :description => "Number of times to ring.", :required => true }}
    put :ring do
      error!("missing :count", 400) unless params[:count]
      @@rang += params[:count].to_i
      { :rang => @@rang }
    end
  end
end

