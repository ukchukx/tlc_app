import "phoenix_html";
import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import VueFlashMessage from 'vue-flash-message';
import axios from 'axios';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { far } from '@fortawesome/free-regular-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import Datetime from 'vue-datetime';
window.jQuery = window.$ = require('jquery');

// Import local files
// import socket from "./socket"
import Dashboard from '@/pages/Dashboard';
import Login from '@/pages/Login';
import Courses from '@/pages/Courses';
import Course from '@/pages/Course';

Vue.config.productionTip = false;

const token = document.head.querySelector('meta[name="csrf-token"]');
if (token) {
  axios.defaults.headers.common['X-CSRF-TOKEN'] = token.content;
}

library.add(fas, far);
Vue.component('fa-icon', FontAwesomeIcon);
Vue.use(BootstrapVue);
Vue.use(Datetime);
Vue.use(VueFlashMessage, { createShortcuts: false });
Vue.component(Dashboard.name, Dashboard);
Vue.component(Login.name, Login);
Vue.component(Courses.name, Courses);
Vue.component(Course.name, Course);

new Vue({
  el: '#app'
});
