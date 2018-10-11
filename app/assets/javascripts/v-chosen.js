Vue.component('v-chosen', {
    data () {
      return {
        localValue: 0,
        modelName: "",
        name_id: "",
        options: [],
        _name: ""
      }
    }, 
    props: ['name', 'model', 'placeholder', 'value', 'label' ],
    template: `
        <div class="inp_w">
        <v-select :value="value"
          :options="options"
          :clearable="false" 
          :placeholder="placeholder"
          v-on:input="onUpdate($event)">
        </v-select>
        <input type="hidden" :value="localValue" v-if="model!=undefined" :id="name_id" :name="_name">
      </div>`,
    created() {

      this.name_id =  this.model + "_" + this.name + "_id";
      this._name =  this.model + "[" + this.name + "_id]";
      this.options = this.$parent[this.name + "s"];
    },
    methods: {
        onUpdate: function (val) {
          this.$parent[this.name] = val
          this.localValue = val === null ? 0 : val.value;
          this.$emit('input', val);
        }
      }
  })