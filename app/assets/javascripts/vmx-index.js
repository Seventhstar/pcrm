var m_created = {
  created: function () {
    this.$root.$on('onInput', this.onInput);
    this.$root.$on('modalYes', this.modalYes);
  },

  methods: {
    formatValue(value, column){
      return column == 'amount' ? toSum(value) : value
    },

    onSubmit(event){
      if (event && !this.formValid) {
        event.preventDefault();
        show_ajax_message(this.noteValid, 'error');
      }
    },

    modalYes(){
      if (this.currentIndex === '' || !this.confirmModal ) return;
      let index = this.mainList.indexOf(this.currentIndex);

      if (index<0) return;
      this.mainList.splice(index, 1);
      delete_item("/" + this.controller + "/" + this.currentIndex.id);
      this.fGroup();
    },
  }
}

var m_index = {

  created(){
    // if (this.filter != undefined) this.filter.push({field: 'actual', value: true})
    this.fGroup();
    // console.log('params', @params)
    // this.city = 
  },
    
  methods: {

    getFiltersList() {
      const filters = this.mainFilters.concat(this.filtersAvailable)
      if (filters == undefined) return {}
      let filter = []
      filters.forEach(f => {
        if (this[f] == undefined) {
          filter.push({name: f, label: undefined, value: undefined}) 
        } else if (typeof(this[f]) == "object" && this[f].length > 0) {
          filter.push({name: f, label: this[f][0].label, value: this[f][0].value})
        } else filter.push({name: f, label: this[f].label, value: this[f].value})
      })
      return filter
    },

    setFilterValue(name, value) {
      //&& this[name + 's'] != undefined
      if (this[name] != undefined ) {
        //let find = this[name + 's'].filter(f => f.value == value)
        //if (find.length > 0) {
          console.log('name', name, this[name], value)
          if (typeof(this[name]) == "string"){
            if (this[name] != value) this[name] = value // find[0] // fill v-chosen
            this.fillFilter(name, value) // add filter like select from chosen
          } else {
            if (this[name].length == 0 || this[name].value != value) this[name] = value // find[0] // fill v-chosen
            this.fillFilter(name, this[name].label) // add filter like select from chosen
          }
          // if (this[name] != undefined) 
          this.$storage.set(name, value)
        //}
      }
    },

    clearAll() {
      this.sortBy("sortdate")
      this.reverse = false;
      for(var f in this.filter) this[this.filter[f].field] = []
      this.filter.length = 0;
    },

    fillFilter(name, value) {
      // console.log('fillFilter', name, value)
      let field = name == 'search' ? this.searchFileds : name
      let s = -1;
      for (var i = 0; i < this.filter.length; i++) {
        if (this.filter[i].field === field) {s = i}
      }
      // console.log('s', s, 'value', value)

      if (s > -1) {
        if (value === undefined) {
          // if (this.readyToChange == undefined || this.readyToChange) {
            console.log('splice fired') 
            this.$storage.remove(name)
            this.filter.splice(s, 1)
          // }
        } else {
          this.filter[s].value = value
          // this.$storage.set(name, value)
        }
      } else if (value != undefined && value != "") {
        this.filter.push({field: field, value: value});
        // this.$storage.set(name, value)
      }        

      this.fGroup();
    },

    onInput(e){
      if (e !== undefined) {
        // if (e.name == 'main_city'){
        //   if (this.city.value != e.value)
        //     this.city = {label: e.label, value: e.value}
        //   this.onCityChange()
          console.log('onInput vmx main_city', e.name, e.label)
        // }

        // if (e.name == 'city'){
        //   // if (nav.city.value != e.value)
        //     // nav.city = {label: e.label, value: e.value}
        //   // this.onCityChange()
          console.log('onInput vmx city', e.name, e.label)
        // }

        if (this.readyToChange == undefined || this.readyToChange) {
          sortable_prepare({}, false, this);
          this.fillFilter(e.name, e.label)
        }
      }
    },
  
    // onCityChange() {

    // },

    sortBy(sortKey, month) {
      if (sortKey == 'date') sortKey = 'sortdate'
      this.reverse = (this.sortKey == sortKey) ? !this.reverse : false;
      this.sortKey = sortKey;
      for (i = 0; i < this.groupHeaders.length; ++i) { 
        let arr = this.grouped[this.groupHeaders[i]]
        if (arr != undefined)
          this.grouped[this.groupHeaders[i]] = this.fSort(arr);
      }
    },

    fGroup(){
      this.grouped      = _.groupBy(this.mainList, 'month')

      this.groupHeaders = Object.keys(this.grouped)
      for (i = 0; i < this.groupHeaders.length; ++i) { 
        let arr = this.grouped[this.groupHeaders[i]]
        if (arr != undefined)
          this.grouped[this.groupHeaders[i]] = this.fSort(arr);
      }
    },

    columnClass(column){
      cls = 'th'
      sortKey = this.sortKey
      if (sortKey == 'sortdate') sortKey = 'date'
      if (sortKey == column) {
        cls = cls + ' current'
        if (this.reverse) cls = cls + ' desc'
      }
      
      return cls
    },

    fSort(arr){
      var vm = this
      let s = this.reverse ? 1 : -1
      let ns = this.reverse ? -1 : 1

      this.filteredData = arr.sort((a,b) => 
        (a[this.sortKey] > b[this.sortKey]) ? ns : ((b[this.sortKey] > a[this.sortKey]) ? s : 0));

      if (this.filter.length > 0) {
        this.filteredData = this.filteredData.filter((item) => {
          for (q in vm.filter) {
            let f = vm.filter[q]
            // console.log('filter f', f, vm.filter)
            let field = f.field.includes(':') ? f.field.split(':')[1] : f.field
            let v = item[field]
            if (v == undefined) continue
            // console.log('typeof(v)', typeof(v), v, f.value, f.field)
            if (typeof(field) == 'object') {
              fl = false
              field.forEach(fld => {if (v != null && item[fld].toLowerCase().indexOf(f.value) > -1) fl = true })
              if (!fl) return false
            } else if (typeof(f.value) == 'object') {
              if (!f.value.includes(v)) return false
              // console.log('v', v, 'f', f, f.value, f.value.includes(v))

            } else if (typeof(v) == 'string') {
              // console.log('v', v, 'vm.filter[q]', vm.filter[q], f.value)
              if (v == null || v.toLowerCase().indexOf(f.value.toLowerCase()) === -1) return false
            } else {
              if (v == null || v != f.value) return false
            }
          }
          return true
        })
      } else return this.filteredData;
      return this.filteredData;
    },

    tdClass(column){
      return 'td ' + (column[0] == 'amount' ? 'td_right' : '')
    },

    tableClass(addClass){
      return "index_table table_" + this.controller + " " + addClass
    },

    fCalcTotal(m){
      if (this.grouped[m] == undefined) return ''
      let total = this.grouped[m].reduce((sum, current) => sum + current['amount'], 0);
      return toSum(total);
    },


    copyLink(id){
      return "/" + this.controller + "/new?from=" + id
    },

    editLink(id){
      return "/" + this.controller + "/" + id + "/edit"
    },

    showLink(id){
      return "/" + this.controller + "/" + id 
    },

    deleteRow(index){
        this.currentIndex = index;
        this.confirmModal = true;
    },

    deleteLink(id){
      return "/" + this.controller + "/" + id 
    }

  }
}