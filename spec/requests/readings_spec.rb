require 'rails_helper'

RSpec.describe "Readings", type: :request do
  before do
    Database.dump
  end

  def populate_database
    valid_readings.each do |reading_params|
      Database.add_record(key: identifier, record: Reading.new(**reading_params))
    end
  end

  let(:identifier) { "awesome_identifier" }
  let(:valid_readings) do
    [
      {
        count: 5,
        timestamp: "2021-09-28T16:08:15+01:00"
      },
      {
        count: 15,
        timestamp: "2021-09-30T16:08:15+01:00"
      },
      {
        count: 10,
        timestamp: "2021-09-29T16:08:15+01:00"
      }
    ]
  end
  let(:invalid_readings) do
    [
      {
        count: 5,
        timestamp: "what is a date"
      },
      {
        not_allowed: 15,
        my_bad: "is not a date"
      }
    ]
  end

  let(:response_body) { JSON.parse(response.body) }

  describe "POST /api/v1/readings/record" do
    let(:valid_params) do
      {
        id: identifier,
        readings: valid_readings
      }
    end

    let(:semi_valid_params) do
      {
        id: identifier,
        readings: valid_readings + invalid_readings
      }
    end

    let(:invalid_params) do
      {
        what_is_this: identifier,
        readings: nil
      }
    end

    context "when the payload is completly valid" do

      context "when received the payload once" do

        it "creates all the readings with status code 201" do
          post record_api_v1_readings_url, params: valid_params
          expect(response).to have_http_status(:created)
          expect(Database.retrieve_record(key: identifier).size).to eq(valid_readings.size)
        end
      end

      context "when received the same payload multiple times" do

        it "only handles the first payload" do
          post record_api_v1_readings_url, params: valid_params
          expect(response).to have_http_status(:created)
          post record_api_v1_readings_url, params: valid_params
          expect(response).to have_http_status(:conflict)
          expect(Database.retrieve_record(key: identifier).size).to eq(valid_readings.size)
        end
      end
    end

    context "when the payload is partially valid" do

      it "creates only the valid readings with status code 201" do
        post record_api_v1_readings_url, params: valid_params
        expect(response).to have_http_status(:created)
        expect(Database.retrieve_record(key: identifier).size).to eq(valid_readings.size)
      end
    end

    context "when the payload is not valid" do

      it "returns a 422 status code" do
        post record_api_v1_readings_url, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "GET /api/v1/readings/:device_id/total_count" do

    before do
      populate_database
    end

    context "when the device_id is valid" do

      it "returns the total count for readings with a 200 status code" do
        get total_count_api_v1_reading_url(device_id: identifier)
        expect(response).to have_http_status(:ok)
        expect(response_body['total_count']).to eq(valid_readings.inject(0) { |total, reading| total + reading[:count] })
      end
    end

    context "when the device_id is not valid" do

      it "responds with a not found status code" do
        get total_count_api_v1_reading_url(device_id: 'anything')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
