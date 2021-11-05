class DrisController < ApplicationController
    include ApplicationHelper

    # respond only to JSON requests
    respond_to :json
    respond_to :html, only: []
    respond_to :xml, only: []

    def read
        @item = Store.find_by_dri(params[:dri]) rescue nil
        if @item.nil?
            render json: {"error": "not found"},
                    status: 404
            return
        end
        render json: JSON.parse(@item.item),
               status: 200
    end

    def info
        history = []
        Store.where(soya_name: params[:dri].to_s).pluck(:dri, :updated_at).sort_by{|i| i[1]}.reverse.each{|i| history << {"schema": i[0], "date": i[1].strftime("%FT%RZ")} }
        if history.length > 1
            history[0], history[1] = history[1], history[0]
        else
            Store.where(dri: params[:dri].to_s).pluck(:dri, :updated_at).each{|i| history << {"schema": i[0], "date": i[1].strftime("%FT%RZ")} }
        end
        overlay = []
        render json: {"history": history, "overlays": overlay},
               status: 200
    end
end