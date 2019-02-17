<template>
  <!-- eslint-disable -->
  <div id="wrapper">
    <Sidebar :current-route="currentRoute" v-if="isStaff" />
    <div id="content-wrapper" class="d-flex flex-column">
      <div id="content">
        <TopBar :user="user" />

        <div class="container-fluid">
          <h1 v-if="isStaff" class="h3 mb-4 text-gray-800">{{ title }}</h1>
          <slot />
        </div>
      </div>
      <Footer />
    </div>
  </div>
</template>
<script>
import TopBar from '@/components/TopBar';
import Footer from '@/components/Footer';
import Sidebar from '@/components/Sidebar';

export default {
  name: 'Page',
  components: {
    TopBar,
    Sidebar,
    Footer
  },
  props: {
    currentRoute: {
      type: String,
      default: () => ''
    },
    title: {
      type: String,
      default: () => ''
    },
    user: {
      type: Object,
      default: () => {}
    }
  },
  computed: {
    isStaff() {
      return this.user.role === 'staff';
    }
  }
};
</script>
