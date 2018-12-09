Vue.component('tab-content', {
  template:`<script type="text/x-template" id="tab-content">
              <div>
                {{tab}}
              </div>
            </script>`,
  props: ['tab']
})