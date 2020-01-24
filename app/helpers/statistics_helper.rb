module StatisticsHelper

  def td_class(row, key, data)
    # puts "data.class == Hash #{data.class == Hash}, (row.keys.length-1)/2 = #{(row.keys.length-1)/2}, row.keys.index(key) = #{row.keys.index(key)} "
    keys = row.class == Hash ? row.keys : row
    (keys.index(key) == 0 || (data.class == Hash && ((keys.length-1)/2 == keys.index(key) ) )) ? 'vline' : ''
  end

end