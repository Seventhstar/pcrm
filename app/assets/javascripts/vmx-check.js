var mCheck = {

  methods: {
    vValue(item, emptyValue = undefined){
      if (item == undefined || item.length == 0) return emptyValue
      return item.value
    },
  }

}

