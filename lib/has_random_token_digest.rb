require 'has_random_column'
require 'has_random_token'
require 'openssl'
require 'base64'

module HasRandomColumn
  def has_random_token_digest (options = {}, &block)
    raise ArgumentError, 'No block given' unless block_given?
    options   = {
      :column    => :token_digest,
      :attribute => :token,
      # hash is any object with a digest method that accepts and returns a string
      # if hash is a string, it is looked up with OpenSSL::Digest
      :hash      => 'SHA512',
      # cost is in orders of magnitude
      # if 0, hash 1 time; if 1, hash 10 times; if 2, hash 100 times; ...
      :cost      => 0
    }.merge!(options)
    column    = options[:column]
    attribute = options.delete :attribute
    cost      = options.delete :cost
    hash      = options.delete :hash
    if hash.is_a? String
      hash = OpenSSL::Digest(hash)
    end
    new_block = Proc.new do |random|
      token = instance_exec random, &block
      instance_variable_set :"@#{attribute}", token
      digest = self.class.digest_token(token, cost, hash)
      instance_exec digest, &block
    end
    attr_reader(attribute)
    define_singleton_method :"find_by_#{attribute}" do |token|
      digest = digest_token(token, cost, hash)
      find_by column => instance_exec(digest, &block)
    end
    define_singleton_method :"find_by_#{attribute}!" do |token|
      digest = digest_token(token, cost, hash)
      find_by! column => instance_exec(digest, &block)
    end
    has_random_token(options, &new_block)
  end

  def has_random_hex_token_digest (options = {})
    has_random_token_digest(options) { |random| random.unpack('H*')[0] }
  end

  def has_random_base64_token_digest (options = {})
    has_random_token_digest(options) do |random|
      Base64.strict_encode64(random)
    end
  end

  def has_random_urlsafe_base64_token_digest (options = {})
    has_random_token_digest(options) do |random|
      Base64.urlsafe_encode64(random)
    end
  end

  def digest_token (token, cost, hash)
    (10**cost).times.reduce(token) { |t, i| hash.digest(t) }
  end
end
