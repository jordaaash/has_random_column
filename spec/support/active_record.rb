require 'active_record'
require 'has_random_column/all'

ActiveRecord::Base.establish_connection :adapter  => 'sqlite3',
                                        :database => ':memory:'

def setup_db
  ActiveRecord::Schema.define(:version => 1) do
    create_table :widgets do |t|
      t.string :string
      t.integer :integer
      t.float :float
      t.boolean :boolean
    end

    create_table :integer_widgets do |t|
      t.integer :integer
      t.integer :integer1, :limit => 1
      t.integer :integer2, :limit => 2
      t.integer :integer3, :limit => 3
      t.integer :integer4, :limit => 4
      t.integer :integer5, :limit => 5
      t.integer :integer6, :limit => 6
      t.integer :integer7, :limit => 7
      t.integer :integer8, :limit => 8
      t.integer :integer9, :limit => 9
      t.integer :integer11, :limit => 11
      t.integer :integer100, :limit => 100
    end

    create_table :primary_key_widgets do |t|
    end

    create_table :custom_primary_key_widgets, :id => false do |t|
      t.primary_key :custom_id
    end

    create_table :limit_primary_key_widgets, :id => false do |t|
      t.primary_key :id, :limit => 8
    end

    create_table :custom_limit_primary_key_widgets, :id => false do |t|
      t.primary_key :custom_id, :limit => 8
    end

    create_table :token_widgets do |t|
      t.string :token
      t.string :custom_token
    end

    create_table :token_digest_widgets do |t|
      t.string :token_digest
      t.string :custom_token_digest
    end
  end
end

def teardown_db
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.drop_table(table)
  end
end

class Widget < ActiveRecord::Base
  has_random_column(:string) { SecureRandom.hex }
  has_random_column(:integer) { SecureRandom.random_number(100) }
  has_random_column(:float) { SecureRandom.random_number }
  has_random_column(:boolean) { [true, false].sample }
end

class IntegerWidget < ActiveRecord::Base
  [:integer, :integer1, :integer2, :integer3, :integer4, :integer5, :integer6,
   :integer7, :integer8, :integer9, :integer11, :integer100].each do |column|
    has_random_integer_column(column) do |maximum|
      SecureRandom.random_number(maximum)
    end
  end
end

class PrimaryKeyWidget < ActiveRecord::Base
  has_random_primary_key
end

class CustomPrimaryKeyWidget < ActiveRecord::Base
  has_random_primary_key :column => :custom_id
end

class LimitPrimaryKeyWidget < ActiveRecord::Base
  has_random_primary_key
end

class CustomLimitPrimaryKeyWidget < ActiveRecord::Base
  has_random_primary_key :column => :custom_id
end

class TokenWidget < ActiveRecord::Base
  has_random_token
  has_random_token :column => :custom_token
end

class TokenDigestWidget < ActiveRecord::Base
  has_random_token_digest
  has_random_token_digest :column => :custom_token_digest
end
