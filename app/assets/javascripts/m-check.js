Vue.component('m-checkbox', {
  data(){
    return {_name: ""}
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
    return {classes: "txt "}
  },
  props: ['name', 'label', 'type', 'value'],
  template: `
    <div class="inp_w prj_not_simple">
      <label>{{label}}</label>
      <input 
        value="0.0" 
        type="text"  
        :class="classes"  
        :value="$parent[name]"
        
        @keyup="onUpdate($event.target.value)"
        id="project_footag1e" 
        style="text-align: right;"></div>`,
    created(){
      // console.log(this.name)
      if (this.name.includes('footage'))
         {this.classes = "txt float_mask"}
      else {this.classes = "txt sum_mask"}

    },
    methods:{
      onUpdate(val) {
        console.log("val", val)
        this.$parent[this.name] = val.toString().replace(/\s/g, '');
      }
    }
});