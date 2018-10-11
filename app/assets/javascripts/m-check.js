Vue.component('m-checkbox', {
  data(){
    return {_name: null}
  },
  props: ['label', 'value', 'name', 'model'],
  template: `
    <label class="checkcontainer">{{label}}
      <input type="hidden" :name="_name" value="">
      <input type="checkbox" 
            :checked="value" 
            class="hidden_checkbox" 
            :name="_name"
            @change="$emit('input', $event.target.checked)">
      <span class="checkmark" v-bind:class="{checked: value}"></span>
    </label>`,
    created() {
      this._name =  this.model + "[" + this.name + "]";
    }
});

Vue.component('m-label',{
  props: ['model', 'name', 'value'],
  template: `
  <div class="lbl">
     {{ label }}
  </div>`,
  methods: {
    label(){
      return model.reason_name
    }
  }

});