const store = new Vuex.Store({
  state: {
    count: 0,
    searchText: 'wefwe'
  },

  mutations: {
    increment (state) {
      state.count++
    },
    setSearchTexts (state, newSearchText) {
      state.searchText = newSearchText
    }
  }
})
