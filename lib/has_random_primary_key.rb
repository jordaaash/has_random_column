require 'has_random_column'
require 'has_random_integer'
require 'securerandom'

module HasRandomColumn
  def has_random_primary_key (options = {}, &block)
    options = {
      :column => nil,
      :unique => true
    }.merge!(options)
    column  = options.delete(:column) || primary_key
    unless block_given?
      # Since 0 <= SecureRandom.random_number(n) < n may = 0, add 1
      block = Proc.new { |maximum| SecureRandom.random_number(maximum) + 1 }
    end
    has_random_integer(column, options, &block)
  end
end
