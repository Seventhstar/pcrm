var vmxGoods = {
  mounted(){
    this.$root.$on('onInput', this.onInput);
    this.$root.$on('modalYes', this.modalYes);
    document.body.addEventListener('keyup', e => {if (e.keyCode === 45) this.addRow();});
  },

  methods: {

    formatTotal(amountArray){
      let string = ""
      if (amountArray === undefined) return ""
      this.currencies.forEach( c => {
        amount = amountArray[c.value];
        if (amount > 0) {string = string + toSum(amount) + c.short + ", "}
      })
      return string.slice(0, -2)
    },

    toolTip(g){
      let toolTip = ''
      if (!v_nil(g.date_place)) toolTip = 'Дата предложения: ' + format_date(g.date_place) + '\n'
      if (!v_nil(g.date_offer)) toolTip = toolTip + 'Дата заказа: ' + format_date(g.date_offer) + '\n'
      if (!v_nil(g.date_supply)) toolTip = toolTip + 'Дата поставки: ' + format_date(g.date_supply) + '\n'

      return toolTip
    },

    toCurrencyAmount(amount, currency_short){
      return ' ' + toSum(amount) + ' ' + currency_short
    },

    currencyShortName(id){
      if (this.currencies == undefined || id < 1) return ""
      if (this.currencies[id-1] == undefined) return ""
      return this.currencies[id-1].short
    },

    allAmount(g){
      let cur_name = ' ' + g.currency_short
      offer = g.gsum > 0 ? g.gsum : ''
      hasOrder = g.order && g.sum_supply != g.gsum
      orderCurrency = ""
      order = hasOrder ? this.toCurrencyAmount(g.sum_supply, this.currencyShortName(g.order_currency_id)) : ''
      offer = hasOrder ? "<span class='striked'> " + this.toCurrencyAmount(offer, g.currency_short) 
                       + '</span></br>' : this.toCurrencyAmount(offer, g.currency_short)
      return offer + ' ' + order 
    },

    oldNewText(g, name, order_name){
      oldName = g[name]
      newName = g[order_name]
      hasOrderName = g.order && oldName != newName && newName != undefined
      order = hasOrderName ? newName : ''
      offer = hasOrderName ? "<span class='striked gray'> " + oldName 
                              + '</span></br>' : oldName

      return offer + ' ' + order
    },

    goodsName(g) {
      // hasOrderName = g.order && g.name != g.order_name && g.order_name != undefined
      // order = hasOrderName ? g.order_name : ''
      // offer = hasOrderName ? "<span class='striked gray'> " + g.name 
      //                         + '</span></br>' : g.name

      // return offer + ' ' + order
      return this.oldNewText(g, "name", "order_name")
    },

    providersName(g) {
      return this.oldNewText(g, "provider_name", "order_provider_name")
    },

    hasFile(g_id){
      has = this.goods_files.filter(w => w.owner_id === parseInt(g_id))
      return has.length>0;
    },

    format_date(date){
      return format_date(date);
    },

    rowClass(g){
      if (g.fixed)
        cls = "fixed"
      else if (g.sum_supply>0)
        cls = "ordered" 
      else
        cls = "placed"
            
      return "grid_table_goods grid_table sw_color " + cls
    },

    goodsDeleteLink(g){
      return "/project_goods/" + g.id 
    },

    v_nil(value){
      return v_nil(value);
    },


  }
}
