import "phoenix_html";
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';

// Import local files
// import socket from "./socket"
import App from '@/components/App';

Vue.config.productionTip = false;

Vue.use(BootstrapVue);
Vue.component(App.name, App);

new Vue({
  el: '#app'
});
