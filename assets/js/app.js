import Vue from 'vue';
import BootstrapVue from 'bootstrap-vue';
import VueFlashMessage from 'vue-flash-message';
import axios from 'axios';
import { library } from '@fortawesome/fontawesome-svg-core';
import { fas } from '@fortawesome/free-solid-svg-icons';
import { far } from '@fortawesome/free-regular-svg-icons';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import Datetime from 'vue-datetime';
// Import local files
// import socket from "./socket"
import Dashboard from '@/pages/Dashboard';
import Login from '@/pages/Login';
import Courses from '@/pages/Courses';
import Course from '@/pages/Course';
import Users from '@/pages/Users';
import User from '@/pages/User';
import Student from '@/pages/Student';
import Attendance from '@/pages/Attendance';

window.jQuery = window.$ = require('jquery'); // eslint-disable-line no-multi-assign

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
Vue.component(Users.name, Users);
Vue.component(User.name, User);
Vue.component(Student.name, Student);
Vue.component(Attendance.name, Attendance);

new Vue({
  el: '#app'
});
