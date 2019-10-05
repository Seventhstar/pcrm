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

Vue.component('m-switcher',{
  data(){
    return {
      classes: '',
      linkClass: '',
      handleClass: '',
      currentLabel: '',
      offLabel: '',
      on: false
    }
  },
  props: ['toggled', 'on-text', 'off-text', 'name'],
  template: `
            <div :class="classes">
              <div class="sep""></div>
              <a :off="offLabel" 
                 :on="onText" 
                 :class="linkClass"
                  v-on:click="onClick()">{{label}}</a>
              <div class="scale" v-on:click="onClick()">
                <div :class="handleClass"></div>
              </div>
            </div>
            `,

  created(){
    this.on = this.$parent[this.name]
    // console.log('this.$parent[name]', this.$parent[this.name], this.name)
    this.offLabel = this.offText == undefined ? this.onText : this.offText
    this.changeState()
  },

  computed: {
    label(){
      return this.currentLabel
    }
  },

  methods: {
      changeState(){
        this.classes      = "switcher_a"
        this.handleClass  = "handle"
        this.linkClass    = "link_c left"
        
        this.currentLabel = this.on ? this.onText : this.offLabel

        if (this.on) this.classes = this.classes + " toggled"
        if (this.on) this.linkClass = this.linkClass + " on"
        if (this.on) this.handleClass = this.handleClass + " active"
      },

      onClick(){
        this.on=!this.on
        this.$parent[this.name] = this.on;
        this.changeState()

      },
  }



});


Vue.component('m-number', {
  data(){
    return {
      _parent: '',
      classes: "txt ",
      name_id: ""}
  },
  props: ['name', 'label', 'type', 'add_class', 'disabled', 'readonly', 'float', 'footage'],
  template: `
    <div class="inp_w prj_not_simple">
      <label v-if="label" :readonly="readonly">{{label}}</label>
      <input 
        value="0.0" 
        type="text"  
        :class="classes"  
        :value="_parent[name]"
        :id="name_id" 
        :name="_name"
        :disabled="disabled"
        :readonly="readonly"
        @keyup="onUpdate($event)"
        @focus="onFocus($event)"
        style="text-align: right;"></div>
        `,

    created(){
      if (this.$parent.model == undefined){
        this._parent = this.$parent.$parent 
      } else this._parent = this.$parent
      if (this._parent == undefined) this._parent = this.$parent
      // console.log('this.$parent', this.$parent, this.name )

      modelName = this._parent.model 
      // if (modelName == undefined) modelName = this.$parent.$parent.model
      this.name_id = modelName + "_" + this.name;
      this._name = modelName + "[" + this.name+"]";
      
      let type = this.type == undefined ? '' : this.type
      // console.log('this.footage', this.footage)

      if (this.name.includes('footage') || type.includes('footage') || this.footage) {
        this.classes = "txt footage_mask"
      } else if (type.includes('percent')) {
        this.classes = "txt discount_mask"
      } else if (type.includes('float') || this.float) {
        this.classes = "txt float_mask"
      } else {
        this.classes = "txt sum_mask"
      }

      if (this.add_class !== undefined)
        this.classes = this.classes + " " + this.add_class
      else if (this.name.includes('total'))
        this.classes = this.classes + " sum_total"
    },

    methods: {
      onFocus(el){
        let val = this._parent[this.name]
        this._parent.focus = this.name;
        if (val == '0' || val == '0,0' || val == '0.0' )
            this._parent[this.name] = '';
      },

      onUpdate(val) {
        let v = val.target.value.toString().replace(/\s/g, '')
        this._parent[this.name] = v
        this.$root.$emit('onInput', {value: v, name: this.name });
      }
    }
});