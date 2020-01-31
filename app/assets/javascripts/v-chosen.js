Vue.component('v-chosen', {
    data() {
      return {
        model: "",
        idName: "",
        localName: "",
        localValue: 0,
        nameParts: '',
        options: [],
        h_input: false,
        clearable: false
      }
    }, 
    props: ['name', 'placeholder', 'label', 'src', 'selected', 
            'readonly', 'disabled', 'storable',
            'owner', 'k', 'index', 'from_array', 'clear', 'input'],
    template: `
        <div class="inp_w">
        <v-select 
          :value="$parent[name]"
          :options="options"
          :clearable=clearable 
          :placeholder="placeholder"
          :readonly=readonly
          :disabled=disabled
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
               v-if="model!=undefined && h_input" :id="idName">
        
      </div>`,
    beforeCreate() {
      // console.log('this.modalCurrency', this.modalCurrency)

    },

    created() {
      // console.log('input', this.input) reason
      this.h_input = this.input == true
      // this.h_input = true
      // console.log('this.$parent[this.name]', this.name, this.$parent[this.name])

       // console.log('this.clear', this.clear, typeof(this.clear))
      if (this.clear != undefined) this.clearable = (!this.clear)
      else 
        this.clearable = false

      let model = '';
      if (this.owner !== undefined) { 
        model = this.owner; 
      } else {         
        model = this.$parent.model; 
      }

      if (model === undefined) {
        this.idName = this.name + "_id";
        this.localName = this.name + "_id";
      } else {
        this.idName = model + "_" + this.name + "_id";
        this.localName = model + "[" + this.name + "_id]";
      }

      if (this.src !== undefined) {
          src = this.$parent[this.src];
          this.options = (this.from_array === undefined || src[this.index] === undefined) ? src : src[this.index][this.from_array];
      } else {
        console.log('try add s on end', this.name, this.$parent[this.name + "s"])
        this.options = this.$parent[this.name + "s"];
        if (this.options == undefined && this.name.slice(-1) == 'y')
          this.options = this.$parent[this.name.slice(0, -1) + "ies"];

      }
      // console.log(this.name, 'this.options', this.options)
      // console.log(this.name, 'this.selected', this.selected)
      // console.log('this.$parent[this.name]', this.$parent[this.name], 'this.name', this.name)
      // this.hostCell = this.$parent[this.name]

      if (this.options !== undefined){
        if (this.selected !== undefined) {
          // console.log('selected type', typeof(this.selected), )
          // if (typeof(this.selected) == 'string')
              // this.options.indexOf(this.selected)
          this.onUpdate(this.options[this.selected])
        } else if (this.options.length === 1) {
          this.onUpdate(this.options[0])
        } else {
          // let ind = this.options.indexOf(this.$parent[this.name])
          let ind = this.options.filter(x => x.name == this.$parent[this.name])

        // if (this.name.includes('.')){
          // this.nameParts = this.name.split('.')
          // let current = this.$parent[this.nameParts[0]]
          // this.hostCell = this.$parent[this.nameParts[0]][this.nameParts[1]+'_id']
          // selected = {value: current[this.nameParts[1]+'_id'], label: current[this.nameParts[1]+'_name']}
          // console.log('selected', this.$parent[this.name], 'ind', ind)
          // if (ind != -1) this.onUpdate(this.$parent[this.name])
        }  

        if (this.options.indexOf(this.$parent[this.name]) === -1 && this.from_array !== undefined) {
          // this.onUpdate()
        }
        // this.$root.$emit('filledChosen', {value: this.localValue, key: this.k, index: this.index, name: this.name, label: label});
      }
    },

    methods: {
      onUpdate(value) {
        val = value
        if (val === undefined) {this.$parent[this.name] = []; return;}

        if (typeof(val) != "object"){
          let find = this.options.filter(f => f.value == value)
          if (find.length > 0) {
            val = find[0]
          } else {
            this.$parent[this.name] = []; 
            return;
          }
        } 

        let label = (v_nil(val)) ? undefined : val.label;
        this.localValue = (v_nil(val)) ? 0 : val.value;
        this.$parent[this.name] = val
        // console.log('v-chosen onUpdate', this.localValue, this.name)
        this.$root.$emit('onInput', {value: this.localValue, key: this.k, index: this.index, name: this.name, label: label});
        if (this.storable) localStorage[this.name] = this.localValue
      },
    } 
  })