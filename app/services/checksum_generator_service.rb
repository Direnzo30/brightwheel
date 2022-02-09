require 'digest/md5'

class ChecksumGeneratorService

  def self.call(hash:)
    new(hash: hash).call
  end

  def initialize(hash:)
    @hash = hash
  end

  def call
    raise 'Content is not a hash' unless @hash.is_a? Hash

    Digest::MD5.hexdigest(Marshal.dump(@hash))
  end
end