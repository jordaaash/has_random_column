require 'has_random_column/gem_version'

module HasRandomColumn
  # Returns the version of the currently loaded HasRandomColumn as a <tt>Gem::Version</tt>
  def self.version
    gem_version
  end
end
