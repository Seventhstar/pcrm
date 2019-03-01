Vue.component('v-chosen', {
    data() {
      return {
        model: "",
        idName: "",
        localName: "",
        localValue: 0,
        options: [],
        clearable: true
      }
    }, 
    props: ['name', 'placeholder', 'label', 'src', 'selected', 
            'owner', 'k', 'index', 'from_array', 'clear'
            ],
    template: `
        <div class="inp_w">
        <v-select 
          :value="$parent[name]"
          :options="options"
          :clearable=clearable 
          :placeholder="placeholder"
          @input="onUpdate($event)">
          <template slot="option" slot-scope="option">
            <span v-if="option.mark" class='info'>{{ option.label }}!</span>
            <template v-else>
              {{ option.label }}
            </template>
        </template>
        </v-select>
        <input type="hidden" :name="localName" :value="localValue" 
               v-if="model!=undefined" :id="idName">
      </div>`,

    created() {

       // console.log('this.clear', this.clear, typeof(this.clear))
      //if (this.clear != undefined) this.clearable = (this.clear == 'true')
      //else 
      //  this.clearable = false

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
        this.options = this.$parent[this.name + "s"];
      }


      if (this.options !== undefined){
        if (this.selected !== undefined) {
          this.onUpdate(this.options[this.selected])
        } else if (this.options.length === 1) {
          this.onUpdate(this.options[0])
        }
        if (this.options.indexOf(this.$parent[this.name]) === -1 && this.from_array !== undefined) this.onUpdate()
      }
    },

    methods: {
        onUpdate: function(val) {
          if (val === undefined) {this.$parent[this.name] = []; return;}
          let label = (v_nil(val)) ? undefined : val.label;
          this.localValue = (v_nil(val)) ? 0 : val.value;
          this.$parent[this.name] = val
                                       
          this.$root.$emit('onInput', {value: this.localValue, key: this.k, index: this.index, name: this.name, label: label});
        }
      }
  })