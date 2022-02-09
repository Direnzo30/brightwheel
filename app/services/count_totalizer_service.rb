class CountTotalizerService

  def self.call(device_id:)
    new(device_id: device_id).call
  end

  def initialize(device_id:)
    @device_id = device_id
  end

  def call
    readings = Database.retrieve_record(key: @device_id)
    return [
      :not_found,
      { 
        error: "Readings for device #{@device_id} not found"
      }
    ] if readings.nil?

    [
      :ok,
      {
        total_count: readings.inject(0) { |total, reading| total + reading.count }
      }
    ]
  end
end
