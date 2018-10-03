Vue.component('v-chosen', {
    data () {
      return {
        localValue: 0,
        options: [],
        modelName: "",
        name_id: "",
        _name: ""
      }
    }, 
    props: ['name', 'placeholder', 'value' ],
    template: `
    <div class="d">
      <v-select :value="value"
        :options="options"
        :clearable="false" 
        :placeholder="placeholder"
        v-on:input="onUpdate($event)">
      </v-select>
      <input type="hidden" :value="localValue" :id="name_id" :name="_name">
    </div>`,
    created() {
      this.name_id =  "absence_" + this.name + "_id";
      this._name =  "absence[" + this.name + "_id]";
      //this.modelName = this.$parent[this.name];
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