Vue.component('m-checkbox', {
  data(){
    return {_name: ""}
  },
  props: ['label', 'value', 'name', 'model'],
  template: `
    <label class="checkcontainer">{{label}}
      <input type="hidden" :name="_name" value="">
      <input type="checkbox" 
            :name="_name"
            :checked="value" 
            class="hidden_checkbox" 
            @change="$emit('input', $event.target.checked)">
      <span class="checkmark" v-bind:class="{checked: value}"></span>
    </label>`,
    created(){
        this._name = this.name === undefined ? "" : this.model + "[" + this.name + "]";
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

Vue.component('m-number', {
  data(){
    return {
      classes: "txt ",
      name_id: ""}
  },
  props: ['name', 'label', 'type', 'add_class', 'disabled'],
  template: `
    <div class="inp_w prj_not_simple">
      <label v-if="label">{{label}}</label>
      <input 
        value="0.0" 
        type="text"  
        :class="classes"  
        :value="$parent[name]"
        :id="name_id" 
        :name="_name"
        :disabled="disabled"
        @keyup="onUpdate($event)"
        @focus="onFocus($event)"
        style="text-align: right;"></div>`,
    created(){
      this.name_id =  this.$parent.model + "_" + this.name;
      this._name =  this.$parent.model + "[" + this.name+"]";
      
      if (this._name.includes('[disc'))
        {this.classes = "txt discount_mask"}
      else if (this.name.includes('footage'))
          {this.classes = "txt float_mask"}
      else {this.classes = "txt sum_mask"}

      if (this.add_class !== undefined)
        this.classes = this.classes + " " + this.add_class
      else if (this.name.includes('total'))
        this.classes = this.classes + " sum_total"
    },
    methods:{
      onFocus(el){
        let val = this.$parent[this.name]
        this.$parent.focus = this.name;
        if (val == '0' || val=='0,0' || val=='0.0' )
            this.$parent[this.name] = '';
      },
      onUpdate(val) {
        this.$parent[this.name] = val.target.value.toString().replace(/\s/g, '');
      }
    }
});