module Enumerable
  def count_by &block
    groups = group_by &block
    groups.keys.each{|key| groups[key] = groups[key].size}
    groups
  end
end