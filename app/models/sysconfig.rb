class Sysconfig < ActiveRecord::Base
  cache_it :singleton

  def self.singleton
    conds = { :singleton => true }
    cache_it.find(conds) || create(conds)
  end
end
