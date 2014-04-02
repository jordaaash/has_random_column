require 'has_random_column/has_random_integer'
require 'securerandom'
require 'active_record/base'

module HasRandomColumn
  module HasRandomPrimaryKey
    include HasRandomInteger

    def has_random_primary_key (options = {}, &block)
      options = {
        :column => nil,
        :unique => true
      }.merge!(options)
      column  = options.delete(:column) || primary_key
      unless block_given?
        # + 1 since 0 <= SecureRandom.random_number(n) < n may = 0
        block = Proc.new { |maximum| SecureRandom.random_number(maximum) + 1 }
      end
      has_random_integer(column, options, &block)
    end
  end
end

ActiveRecord::Base.send :extend, HasRandomColumn::HasRandomPrimaryKey
