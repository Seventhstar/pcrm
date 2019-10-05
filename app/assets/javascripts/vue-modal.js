    Vue.component("confirmation-modal", {
      data(){return {objName: ""}},
      template:`<div class="modal-dlg" @keyup.enter="onConfirm" @keyup.esc="$emit('close')" tabindex="0">
                  <div class="modal-message">
                    <div class="hl hl_a bd">Действительно хотите удалить {{objName}}?</div>
                    <div class="actions">
                     <span class="btn sub btn_a btn_reset" @click="onCancel">Нет</span>
                     <span class="btn btn btn-default sub btn_a" @click="onConfirm">Да</span>
                     </div>
                  </div>
                </div>`,
      props: ["open", "user"],

      mounted() {
        document.body.addEventListener('keyup', e => {
          if (e.keyCode === 27) this.onCancel(); 
          else if (e.keyCode === 13) this.onConfirm();
        })  
      },

      created() {
        if (typeof(this.$parent.currentTitle) == 'string')
          this.objName = '"' + this.$parent.currentTitle + '"'
        else if (typeof(this.$parent.currentIndex) == 'object')
          this.objName = '"' + this.$parent.currentIndex.name + '"'
      },

      methods: {
        onConfirm() {
          this.$root.$emit('modalYes');
          this.$parent.confirmModal = false;
        },

        onCancel() {
          this.$root.$emit('modalCancel');
          this.$parent.confirmModal = false;
        }
      }
    });