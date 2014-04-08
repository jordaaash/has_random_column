require 'has_random_column/version'
require 'securerandom'
require 'active_record/base'
module HasRandomColumn
  def has_random_column (column, options = {}, &block)
    raise ArgumentError, 'A block is required' unless block_given?
    options = {
      :on     => :create,
      :if     => nil,
      :unique => false
    }.merge!(options)
    unique  = options.delete :unique

    before_validation(options) do
      if unique
        unscoped = self.class.unscoped
        begin
          value = instance_eval &block
        end while unscoped.exists?(column => value)
      else
        value = instance_eval &block
      end
      self[column] = value
    end
  end
end

ActiveRecord::Base.send :extend, HasRandomColumn
