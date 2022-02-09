class ReadingsProcessorService
  attr_accessor :payload

  def self.call(payload:)
    new(payload: payload).call
  end

  def initialize(payload:)
    @payload = payload
  end

  def call
    return :unprocessable_entity if invalid_payload?
    return :conflict if Database.existing_content?(key: payload[:key], content: payload.to_h)

    valids = 0
    payload[:readings].each do |reading_params|
          
      reading = Reading.new(**(reading_params.to_h.symbolize_keys))
      if reading.valid?
        Database.add_record(key: payload[:id], record: reading)
        valids += 1
      end
    end

    valids > 0 ? :created : :unprocessable_entity
  end

  private
  
  def invalid_payload?
    payload[:id].blank? && payload[:readings]&.map(&:to_h).blank?
  end
end