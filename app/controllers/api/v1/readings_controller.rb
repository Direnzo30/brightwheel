module Api
  module V1
    class ReadingsController < ApplicationController

      def record
        head ReadingsProcessorService.call(payload: record_params)
      end

      def most_recent

      end

      def total_count
        status, response = CountTotalizerService.call(device_id: params[:device_id].to_s)
        render json: response, status: status
      end

      private

      def record_params
        params.permit(:id, readings: [:timestamp, :count])
      end
    end
  end
end
