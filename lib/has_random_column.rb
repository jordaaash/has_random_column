require 'has_random_column/version'
require 'securerandom'
require 'active_record/base'

module HasRandomColumn
  def has_random_column (column, options = {}, &block)
    raise ArgumentError, 'No block given' unless block_given?
    options = {
      :on     => :create,
      :if     => nil,
      :unique => false
    }.merge!(options)
    if options.delete(:unique)
      new_block = Proc.new do
        unscoped = self.class.unscoped
        begin
          value = instance_eval(&block)
        end while unscoped.exists?(column => value)
        self[column] = value
      end
    else
      new_block = Proc.new { self[column] = instance_eval(&block) }
    end
    before_validation(options, &new_block)
  end
end

ActiveRecord::Base.send :extend, HasRandomColumn
