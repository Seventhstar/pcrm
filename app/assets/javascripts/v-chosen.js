Vue.component('v-chosen', {
    data() {
      return {
        model: "",
        idName: "",
        localName: "",
        emptyText: "Выберите...",
        localValue: 0,
        nameParts: '',
        options: [],
        h_input: false,
        clearable: false
      }
    }, 
    props: ['name', 'placeholder', 'label', 'src', 'selected', 
            'readonly', 'disabled', 'storable', 'input_name',
            'owner', 'k', 'index', 'from_array', 'clear', 'input'],
    template: `
        <div class="inp_w">
        <v-select
          :value="$parent[name]"
          :options="options"
          :clearable=clearable 
          :placeholder="emptyText"
          :disabled=readonly
          @input="onUpdate($event)">
          <template slot="option" slot-scope="option">
            <span v-if="option.mark" class='info'>{{ option.label }}</span>
            <span v-else-if="option.non_actual" class='nonactual'>{{ option.label }}</span>
            <template v-else>
              {{ option.label }}
            </template>
        </template>
        </v-select>        
        <input type="hidden" :name="localName" :value="localValue" 
               v-if="(model!=undefined && h_input) || input_name" :id="idName">
        
      </div>`,

          // :value="$parent[name]"
          
    created() {
      // console.log('name', this.name, this.selected, this.$parent[this.name], this.$parent.city.value )
      this.h_input = this.input == true

      if (this.clear != undefined) this.clearable = (!this.clear)
      else 
        this.clearable = false

      if (this.placeholder != undefined) this.emptyText = this.placeholder

      let model = ''
      if (this.owner !== undefined) { 
        model = this.owner
      } else {         
        model = this.$parent.model
      }

      if (this.input_name != undefined) {
        // console.log('this.input_name', this.input_name, 'this.name', this.name)
        this.localName = this.input_name
      } else if (model === undefined) {
        this.idName = this.name + "_id"
        this.localName = this.name + "_id"
      } else {
        this.idName = model + "_" + this.name + "_id"
        this.localName = model + "[" + this.name + "_id]"
      }

      if (this.src !== undefined) {
          src = this.$parent[this.src]
          this.options = (this.from_array === undefined || src[this.index] === undefined) ? src : src[this.index][this.from_array]
      } else {
        this.options = this.$parent[this.name + "s"]
        if (this.options == undefined && this.name.slice(-1) == 'y')
          this.options = this.$parent[this.name.slice(0, -1) + "ies"]
      }

      if (this.options !== undefined){
        if (this.selected !== undefined) {
          // this.onUpdate(this.options[this.selected])
        } else if (this.options.length === 1) {
          // this.onUpdate(this.options[0])
        } else {
          let ind = this.options.filter(x => x.name == this.$parent[this.name])
        }  
      }

      // console.log('this.name', this.name, 'this.localName', this.localName, 'this.value', this.value)
    },

    mounted() {
      if (this.name.includes('.')){
        // console.log('mounted this.name', this.name) 
        this.$root.$watch(this.name, (e) => {
          // console.log('mounted watch name', this.name, 'e', e)
          this.onUpdate(e)
        })
      }
    },

    methods: {
      onUpdate(value) {
        val = value
        if (val === undefined) {this.$parent[this.name] = undefined; return}
        if (typeof(val) != "object" && this.options.filter != undefined) {
          let find = this.options.filter(f => f.value == value)
          if (find.length > 0) val = find[0]
          else { this.$parent[this.name] = undefined; return }
        }
        // console.log('localName', this.localName, 'value', value, 'find', find.length, this.options)
        let label = (v_nil(val)) ? undefined : val.label

        if (v_nil(val)) val = null
        this.localValue = (v_nil(val)) ? null : val.value
        this.$parent[this.name] = val
        this.$emit('input', val)
        this.$root.$emit('onInput', {value: this.localValue, key: this.k, index: this.index, name: this.name, label: label})
        if (typeof(val) == "object" && value == this.$parent[this.name]) return
        if (this.storable) localStorage[this.name] = this.localValue
      },
    } 
  })