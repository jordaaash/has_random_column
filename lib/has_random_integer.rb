require 'has_random_column'
require 'securerandom'

module HasRandomColumn
  def has_random_integer (column, options = {}, &block)
    options = { :maximum => nil }.merge!(options)
    maximum = options.delete(:maximum) || maximum_integer_value(column)
    if block_given?
      new_block = Proc.new { instance_exec maximum, &block }
    else
      # Since 0 <= SecureRandom.random_number(n) < n is < n, add 1
      new_block = Proc.new { SecureRandom.random_number(maximum + 1) }
    end
    has_random_column(column, options, &new_block)
  end

  def maximum_integer_value (column)
    # Rails defines unsigned integer columns with default limit=nil
    # MySQL:      https://dev.mysql.com/doc/refman/5.7/en/integer-types.html
    # PostgreSQL: http://www.postgresql.org/docs/9.3/static/datatype-numeric.html
    case columns_hash[column].limit
    when nil, 4, 11 then 2_147_483_647             # integer (Rails default)
    when 5..8       then 9_223_372_036_854_775_807 # bigint
    when 3          then 8_388_607                 # mediumint
    when 2          then 32_767                    # smallint
    when 1          then 127                       # tinyint
    else raise ArgumentError, "The maximum value for column #{column} could " \
                              "not be determined."
    end
  end
end
