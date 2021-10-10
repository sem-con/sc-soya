module Api
    module V1
        class SoyasController < ApiController
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            def similar
                render json: ["https://soya.data-container.net/Person_v1", "https://soya.data-container.net/zQmRjghcyXqQR55BAsAwxWRBWa9FAncVgnbQn4BZXMzVDwT"],
                       status: 200
            end
        end
    end
end
