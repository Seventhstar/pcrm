Vue.component('v-chosen', {
    data() {
      return {
        model: "",
        idName: "",
        localName: "",
        localValue: 0,
        options: []
      }
    }, 
    props: ['name', 'placeholder', 'label', 'src', 
            'owner', 'k', 'index', 'from_array'],
    template: `
        <div class="inp_w">
        <v-select 
          :value="$parent[name]"
          :options="options"
          :clearable="false" 
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
      let model = '';
      if (this.owner!==undefined) { 
        model = this.owner; 
      } else {         
        model = this.$parent.model; 
      }

      this.idName =  model + "_" + this.name + "_id";
      this.localName =  model + "[" + this.name + "_id]";

      if (this.src !== undefined) {
          src = this.$parent[this.src];
          //console.log("src", src, src[this.index], "this.from_array", this.from_array );
          this.options = (this.from_array === undefined || src[this.index] === undefined) ? src : src[this.index][this.from_array];
      } else {
        this.options = this.$parent[this.name + "s"];
      }

    },

    mounted(){
      if (this.options !== undefined && this.options.length === 1) this.onUpdate(this.options[0])
    },

    methods: {
        onUpdate: function(val) {
          this.localValue = (val === null) ? 0 : val.value;
          this.$parent[this.name] = val
          this.$root.$emit('onInput', {value: this.localValue, key: this.k, index: this.index});
        }
      }
  })