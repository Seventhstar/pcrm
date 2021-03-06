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
              id="top-search"
              class="search_area txt"
              placeholder="Поиск..."
              @blur="blur" 
              @focus="focus" 
              @input="inputChange"
              @keyup.enter="keyEnter" 
              @keydown.tab="keyEnter" 
              @keydown.up="keyUp"
              @keydown.down="keyDown" >
        <button title="Очистить" type="button" class="clear" @click="clearSearch" ><span>× </span></button>
      </div>
    <ul role="listbox" class="dropdown-menu" style="max-height: 400px;" v-show="show">
      <li role="option" v-for="item, i in internalItems" @click="onClickItem(item)" 
      :class="{'v-autocomplete-item-active': i === cursor}" @mouseover="cursor = i"><a>{{item}}</a></li> 
    </ul>
  </div>`,

  computed: {
    hasItems () {
      return !this.internalItems.length
    },
    show () {
      return (this.showList && this.internalItems.length)
    }
  },

  methods: {
    clearSearch() {
      this.searchText = ''
      this.$root.$emit('search', '')
      // console.log('clearSearch', this.searchText)
      store.commit('setSearchTexts', "")
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
      this.$root.$emit('search', this.searchText)
      store.commit('setSearchTexts', this.searchText)
      console.log('inputChange', this.searchText)
    },

    updateItems () {
      this.$emit('update-items', this.searchText)
    },

    focus () {
      // this.$emit('focus', this.searchText)
    },

    blur () {
      // this.$emit('blur', this.searchText)
      // setTimeout(() => this.showList = false, 200)
    },

    onClickItem(item) {
      this.onSelectItem(item)
      this.showList = false
      this.$emit('item-clicked', item)
    },
    
    onSelectItem (item) {
      if (item) {
        this.searchText = item
        // this.$emit('item-selected', item)
      } 
      this.$emit('search', item)
      store.commit('setSearchTexts', item)
    },

    keyUp (e) {
      if (this.cursor > -1) {
        this.cursor--
        // this.itemView(this.$el.getElementsByClassName('v-autocomplete-list-item')[this.cursor])
      }
    },

    keyDown() {
      this.showList = true

      if (this.cursor < this.internalItems.length) {
        this.cursor++
        // this.itemView(this.$el.getElementsByClassName('v-autocomplete-list-item')[this.cursor])
      }
    },

    itemView(item) {
      if (item && item.scrollIntoView) {
        item.scrollIntoView(false)
      }
    },

    keyEnter(e) {
      if (this.searchText == undefined) searchText = ''
      else searchText = this.searchText.toLowerCase()
      if (this.internalItems == undefined) this.internalItems = []
      if (this.internalItems.indexOf(searchText) == -1 )
          this.internalItems.unshift(searchText)
      if (this.internalItems.length > 8) this.internalItems.length = 8
      Vue.$storage.set('search', this.internalItems)

      if (this.showList && this.internalItems[this.cursor]) 
        this.onSelectItem(this.internalItems[this.cursor])
      
      this.showList = false
      // console.log('keyEnter(e)', e)
    },

    findItem (items, text, autoSelectOneResult) {
      if (!text) return
      if (autoSelectOneResult && items.length == 1) {
        return items[0]
      }
    }
  },
  
  created () {
    window.Vue.use(window.Vue2Storage)
    let searchTexts = Vue.$storage.get('search')
    if (searchTexts != undefined ) {
      if (searchTexts.constructor == Array)
        this.internalItems = searchTexts 
      else if (searchTexts.constructor == String) 
        this.internalItems = [searchTexts]
      if (this.value !== undefined) this.onSelectItem(this.value)
      else this.searchText = this.$parent.search
    }
  },

  watch: {
    items (newValue) {
      this.setItems(newValue)
      let item = this.findItem(this.items, this.searchText, this.autoSelectOneItem)
      if (item) {
        this.onSelectItem(item)
        this.showList = false
      }
    },
  }
})