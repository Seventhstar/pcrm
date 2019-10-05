# @ItemByID = (id, list) ->
#   # found = list.filter(f => f.value == toInt(id))
#   found = list.filter (f) ->
#     f.value == toInt(id)
#     return
#   console.log('found', found, 'id', toInt(id), 'list', list)
#   return {label: found[0].label, value: id}