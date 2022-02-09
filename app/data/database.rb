# This solution might not be thread-safe
class Database
  class << self
    attr_accessor :records, :checksums

    def add_record(key:, record:)
      if records.has_key? key
        records[key] << record
      else
        records[key] = [record]
      end
    end

    def retrieve_record(key:)
      records[key]
    end

    def existing_content?(key:, content:)
      checksum = ChecksumGeneratorService.call(hash: content)
      existing_key = checksums.has_key?(key)
      return true if existing_key && checksums[key].include?(checksum)

      if existing_key
        checksums[key] << checksum
      else
        checksums[key] = [checksum]
      end
      false
    end

    def dump
      @records = {}
      @checksums = {}
    end
  end

  @records = {}
  @checksums = {}
end
