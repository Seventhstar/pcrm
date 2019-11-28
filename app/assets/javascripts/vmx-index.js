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
    this.filter.push({field: 'actual', value: true})
    this.fGroup();
  },
    
  methods: {

    clearAll() {
      this.sortBy("sortdate")
      this.reverse = false;
      for(var f in this.filter) this[this.filter[f].field] = []
      this.filter.length = 0;
    },

    onInput(e){
      if (e !== undefined){
        let s = -1;
        for (var i=0; i < this.filter.length; i++){
          if (this.filter[i].field === e.name) {s = i;}
        }

        if (s > -1){
          if (e.label === undefined)
            this.filter.splice(s, 1)
          else
            this.filter[s].value = e.label
        } 
        else if (e.label !== undefined)
          this.filter.push({field: e.name, value: e.label});
      this.fGroup();
      }
    },
  

    sortBy(sortKey, month) {
      console.log('sortKey', sortKey)
      if (sortKey == 'date') sortKey = 'sortdate'
      this.reverse = (this.sortKey == sortKey) ? !this.reverse : false;
      this.sortKey = sortKey;
      for (i = 0; i < this.groupHeaders.length; ++i) { 
        let arr = this.grouped[this.groupHeaders[i]]
        if (arr != undefined)
          this.grouped[this.groupHeaders[i]] = this.fSort(arr);
        // this.fSort(this.grouped[this.groupHeaders[i]]);
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
      console.log('fGroup', this.mainList.length, this.grouped)
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
            let v = item[f.field]
            if (typeof(v) == 'string') {
              if (v == null || v.toLowerCase().indexOf(vm.filter[q].value.toLowerCase()) === -1) return false
            } else {
              if (v == null || v != vm.filter[q].value) return false
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