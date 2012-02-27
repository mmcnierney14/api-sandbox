module Acme
  class API < Grape::API
    prefix 'api'
    mount ::Acme::API_v1
    get "routes" do
      ::Acme::API_v1::routes.map do |route|
        {
          :description => route.route_description,
          :version => route.route_version,
          :method => route.route_method,
          :path => route.route_path,
          :params => route.route_params
        }
      end
    end
  end
end

