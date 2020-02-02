Vue.component('v-search', {
    data() {
      return {
        model: "",
        store,
        searchText: '',
        showList: false,
        cursor: -1,
        items: [],
        internalItems: []
      }
    },
    name: 'v-search',
    props: {
      value: null,
    },

    template: `  
    <div class="v-autocomplete">
      <div class="" >
        <input v-model="searchText"  
              class="search_area txt"
              placeholder="Поиск..."
              @click="showList = true"
              @blur="blur" 
              @focus="focus" 
              @input="inputChange"
              @keyup.enter="keyEnter" 
              @keydown.tab="keyEnter" 
              @keydown.up="keyUp" 
              @keydown.down="keyDown">
        <button title="Очистить" type="button" class="clear" @click="clearSearch" ><span>× </span></button>
      </div>
    <ul role="listbox" class="dropdown-menu" style="max-height: 400px;" v-show="show">
      <li role="option" v-for="item, i in internalItems" @click="onClickItem(item)" 
      :class="{'v-autocomplete-item-active': i === cursor}" @mouseover="cursor = i"><a>{{item}}</a></li> 
    </ul>
  </div>`,

  computed: {
    hasItems () {
      // console.log('this.internalItems.length', this.internalItems.length)
      return !!this.internalItems.length
    },
    show () {
      // console.log('this.showList', this.showList, 'this.hasItems', this.hasItems)
      return (this.showList && this.internalItems.length)
    }
  },

  methods: {
    clearSearch() {
      this.searchText = ''
      store.commit('setSearchTexts', '')
    },

    isUpdateItems (text) {
      if (text.length >= this.minLen) {
        return true
      }
    },

    callUpdateItems (text, cb) {
      clearTimeout(this.timeout)
      if (this.isUpdateItems(text)) {
        this.timeout = setTimeout(cb, this.wait)
      }
    },

    inputChange () {
      this.cursor = -1
      this.onSelectItem(null, 'inputChange')
      this.callUpdateItems(this.searchText, this.updateItems)
      this.$emit('change', this.searchText)
      store.commit('increment')
      store.commit('setSearchTexts', this.searchText)
    },

    updateItems () {
      this.$emit('update-items', this.searchText)
    },
    focus () {
      this.$emit('focus', this.searchText)
      // this.showList = true
    },
    blur () {
      this.$emit('blur', this.searchText)
      setTimeout( () => this.showList = false, 200)
    },
    onClickItem(item) {
      this.onSelectItem(item)
      this.showList = false
      this.$emit('item-clicked', item)
    },
    onSelectItem (item) {
      if (item) {
        console.log('item', item)
        // this.internalItems = [item]
        this.searchText = item
        // this.searchText = this.getLabel(item)
        this.$emit('item-selected', item)
      } else {
        // this.setItems(this.items)
      }
      this.$emit('input', item)
      store.commit('setSearchTexts', item)
      // delay('sortable_query({})', 700)
    },
    // setItems (items) {
    //   // this.internalItems = items || []
    // },
    // isSelectedValue (value) {
    //   return 1 == this.internalItems.length && value == this.internalItems[0]
    // },
    // keyUp (e) {
    //   if (this.cursor > -1) {
    //     this.cursor--
    //     this.itemView(this.$el.getElementsByClassName('v-autocomplete-list-item')[this.cursor])
    //   }
    // },
    keyDown (e) {
    //   if (this.cursor < this.internalItems.length) {
    //     this.cursor++
    //     this.itemView(this.$el.getElementsByClassName('v-autocomplete-list-item')[this.cursor])
    //   }
    // console.log('')
    // store.commit('increment')
    store.commit('increment')

    this.showList = false
    },
    itemView (item) {
      if (item && item.scrollIntoView) {
        item.scrollIntoView(false)
      }
    },
    keyEnter (e) {
      if (e.key == 'Enter'){
        // console.log('e', e, 'this.internalItems', this.internalItems)
        searchText = this.searchText.toLowerCase()
        if (this.internalItems == undefined) this.internalItems = []
        if (this.internalItems.indexOf(searchText) == -1 )
          this.internalItems.unshift(searchText)
        if (this.internalItems.length>8) this.internalItems.length = 8
        let s = Vue.$storage.set('search', this.internalItems)
      }

      if (this.showList && this.internalItems[this.cursor]) {
        this.onSelectItem(this.internalItems[this.cursor])
      }
      this.showList = false
    },

    findItem (items, text, autoSelectOneResult) {
      if (!text) return
      if (autoSelectOneResult && items.length == 1) {
        return items[0]
      }
    }
  },
  
  created () {
    // utils.minLen = this.minLen
    // utils.wait = this.wait
    console.log('this.value search', this.value)
    console.log('this.parent', this.$parent.search )
    // this.value =

// Vue.use(Vue2Storage, {
  //   prefix: 'absence_',
    window.Vue.use(window.Vue2Storage)
    let searchTexts = Vue.$storage.get('search')
    console.log('searchTexts', searchTexts, typeof(searchTexts) )

    // this.items = s
    if (searchTexts.constructor == Array)
      this.internalItems = searchTexts 
    else if (searchTexts.constructor == String) 
      this.internalItems = [searchTexts]
    // for (var s in searchTexts){
    //   this.items.push(searchTexts[s])

    // }
    console.log('created search=', searchTexts, 'this.internalItems', this.internalItems )
    if (this.value !== undefined) this.onSelectItem(this.value)
    else this.searchText = this.$parent.search

  },

  watch: {
    items (newValue) {
      console.log('items', items)
      this.setItems(newValue)
      let item = this.findItem(this.items, this.searchText, this.autoSelectOneItem)
      if (item) {
        this.onSelectItem(item)
        this.showList = false
      }
    },
    // value (newValue) {
    //   console.log('value', this.value, newValue)
    //   if (!this.isSelectedValue(newValue) ) {
    //     this.onSelectItem(newValue)
    //     this.searchText = this.getLabel(newValue)
    //   }
    // }
  }
})