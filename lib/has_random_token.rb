require 'has_random_column'
require 'securerandom'

module HasRandomColumn
  def has_random_token (options = {}, &block)
    raise ArgumentError, 'No block given' unless block_given?
    options = {
      :column => :token,
      :bytes  => 16,
      :unique => true
    }.merge!(options)
    column  = options.delete :column
    bytes   = options.delete :bytes

    has_random_column(column, options) do
      random = SecureRandom.random_bytes(bytes)
      instance_exec random, &block
    end
  end

  def has_random_hex_token (options = {})
    has_random_token(options) { |token| token.unpack('H*')[0] }
  end

  def has_random_base64_token (options = {})
    has_random_token(options) { |token| Base64.strict_encode64(token) }
  end

  def has_random_urlsafe_base64_token (options = {})
    has_random_token(options) { |token| Base64.urlsafe_encode64(token) }
  end
end
