var m_index = {
  created(){
    this.fGroup()
  },

  mounted() {
    setTimeout(()=>{this.restoreParams()}, 300)
    this.readyToChange = true
  },

  // watch: {
  //   search: (val, oldVal) => {
      
  //   }
  // },

  computed: {
      searchI () {
        // console.log('searchI fired')
        this.fillFilter('search', store.state.searchText)
        return store.state.searchText;
      }
  },
    
  methods: {
    restoreParams() {
      this.filterItems.forEach( f => {
        if (this.params[f] != undefined) {
          this[f] = this.params[f]
          // let p = this[f]
        }
      })
    },

    getPlaceholder(name){
      let val = name
      if (this.translated != undefined) val = this.translated[name] + '...'
      // console.log('name', name, 'this.translated[name]', this.translated[name])
      return val
    },

    groupLabel(month, gIdx) {
      // if (this.grouped[month][0] )
      // console.log(this.grouped[month][0].month_label)
      if (this.groupName.length == 0 || this.groupName == 'month')
        return this.grouped[month][0].month_label  
      return month
    },

    filterItemStyle(){
      let count = this.filterItems.length
      w = (count >3) ? 'calc('+100/this.filterItems.length+'% - 10px)' : '220px'
      return 'width: ' + w 
    },

    getFiltersList() {
      let filters = []
      console.log('filters', filters)
      if (this.mainFilters != undefined) filters = this.mainFilters
      if (this.filtersAvailable != undefined) filters = filters.concat(this.filtersAvailable)
      if (this.filterItems != undefined) filters = filters.concat(this.filterItems)
      
      console.log('filters', filters, this.filterItems)
      if (filters == undefined) return {}
      let filter = []
      filters.forEach(f => {
        if (f == 'search'){
          filter.push({name: f, label: this.search, value: this.search})
        } else if (this[f] == undefined) {
          filter.push({name: f, label: undefined, value: undefined}) 
        } else if (typeof(this[f]) == "object" && this[f].length > 0) {
          filter.push({name: f, label: this[f][0].label, value: this[f][0].value})
        } else filter.push({name: f, label: this[f].label, value: this[f].value})
      })
      return filter
    },

    setFilterValue(name, value) {
      if (this[name] != undefined ) {
        console.log('setFilterValue name', name, 'value', value)
        if (typeof(this[name]) == "string"){
          if (this[name] != value) this[name] = value // find[0] // fill v-chosen
          this.fillFilter(name, value) // add filter like select from chosen
        } else {
          if (this[name].length == 0 || this[name].value != value) this[name] = value // find[0] // fill v-chosen
          this.fillFilter(name, this[name].label) // add filter like select from chosen
        }
        this.$storage.set(name, value)
      }
    },

    clearAll() {
      this.sortBy("sortdate")
      this.reverse = false;
      for(var f in this.filter) this[this.filter[f].field] = []
      this.filter.length = 0;
    },

    fillFilter(name, value, startUpdate = true) {
      console.log('fillFilter', name, value)
      if (this.filter == undefined) return
      let field = name == 'search' ? this.searchFileds : name
      // let field = name
      let s = -1;
      
      for (var i = 0; i < this.filter.length; i++) {
        if (this.filter[i].field === field) {s = i}
      }

      if (s > -1) {
        if (value === undefined) {
            // this.$storage.remove(name)
            this.filter.splice(s, 1)
        } else {this.filter[s].value = value}
      } else if (value != undefined && value != "") {
        this.filter.push({field: field, value: value});
      }        

      if (startUpdate) this.fGroup(this.groupBy)
      sortable_prepare({})
    },

    clearSearch() {
      this.search = ''
      this.fillFilter('search', '')
    },

    onInput(e){
      console.log('e.name', e.name, e.label, e)
      if (e !== undefined ) {
        if (this.readyToChange == undefined || this.readyToChange) {
          if (e.name == 'groupBy') {
            this.fGroup(e.value)
          } else {
            sortable_prepare({}, false, this)
            this.fillFilter(e.name, e.label)
          }
        } else {
          this.fillFilter(e.name, e.label, false)

        }
      }
    },
  
    sortBy(sortKey, month) {
      if (sortKey == 'date') sortKey = 'sortdate'
      this.reverse = (this.sortKey == sortKey) ? !this.reverse : false
      this.sortKey = sortKey;
      for (i = 0; i < this.groupHeaders.length; ++i) { 
        let arr = this.grouped[this.groupHeaders[i]]
        if (arr != undefined)
          this.grouped[this.groupHeaders[i]] = this.fSort(arr)
      }
    },

    fGroup(groupName = ''){
      if (groupName == undefined || groupName.length == 0) this.groupName = 'month'
      else {
        if (typeof(groupName) == 'object') this.groupName = groupName.value
        if (this.groupName.slice(-3) == "_id") this.groupName = this.groupName.slice(0, -3) 
      }
      // this.grouped.length = 0
      this.grouped = _.groupBy(this.mainList, this.groupName)
      this.groupHeaders = Object.keys(this.grouped) 
      console.log('fGroup fired', this.groupName, this.grouped)
      

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
            let field = f.field.includes(':') ? f.field.split(':')[1] : f.field
            let v = item[field]
            // if (v == undefined) break 
            // if (typeof(f.field) != 'object' && v == undefined) continue
            // console.log('filter f', f, vm.filter[q], f.field == 'search')
            if (v == undefined && (f.field != 'search' || f.value == '')) continue
            // console.log('typeof(v)', typeof(v), v, f.value, 'f.field', f.field, f.field == 'search')
            

            if (f.field == 'search') {
              // console.log('here f.field', f.field)
              fl = false
              this.searchFileds.forEach(fld => {
                // console.log('f.value', f.value, 'item[fld]:', item[fld], 'item[fld].toLowerCase().indexOf(f.value)')
                if (!v_nil(item[fld]) && item[fld].toLowerCase().indexOf(f.value) > -1) fl = true 
              })
              if (!fl) return false
            } else if (typeof(f.value) == 'object') {
              // console.log('v', v, 'f', f, f.value, f.value.includes(v))
              if (!f.value.includes(v)) return false
            } else if (typeof(v) == 'string') {
              // return false
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

    tableClass(addClass, objClass){
      return "index_table table_" + this.controller + 
              (objClass != undefined ? " " + objClass : '' )+ 
              " " + addClass
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