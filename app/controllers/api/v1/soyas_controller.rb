module Api
    module V1
        class SoyasController < ApiController
            # respond only to JSON requests
            respond_to :json
            respond_to :html, only: []
            respond_to :xml, only: []

            include BaseHelper
            include SimilarityHelper

            def similar
                puts "similar ======="
                inputAttributes = getAttributes(params)
                puts inputAttributes.to_json

                retval = []

                i = 0
                Store.all.each do |item|
                    if item.dri.to_s != ""
                        simval = similarity(inputAttributes, getAttributes(JSON.parse(item.item)))
                        retval << {:schema => item.dri.to_s, :similarity => simval}
                        i +=1
                        break if i > 20
                    end
                end
                retval = retval.sort_by { |i| i[:similarity] }.reverse

                render json: retval.to_json,
                       status: 200
            end
        end
    end
end
