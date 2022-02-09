class Reading

  include ActiveModel::Validations
  include ActiveModel::Model

  attr_accessor :timestamp, :count

  validates :count, format: { 
    with: /\A[0-9]+\z/,
    message: "must be an integer"
  }

  validate :is_iso8601

  def initialize(timestamp: nil, count: nil)
    @timestamp = timestamp
    @count = count
  end

  private

  def is_iso8601
    begin
      Time.iso8601(timestamp)
    rescue ArgumentError => e
      errors.add(:timestamp, "timestamp should have ISO 8601 format")
    end
  end
end
