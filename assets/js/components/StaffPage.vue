<template>
  <div id="wrapper">
    <Sidebar :current-route="currentRoute" />
    <div id="content-wrapper" class="d-flex flex-column">
      <div id="content">
        <TopBar :user="user" />

        <div class="container-fluid">
          <h1 class="h3 mb-4 text-gray-800">{{ title }}</h1>
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
  name: 'StaffPage',
  components: {
    TopBar,
    Sidebar,
    Footer
  },
  props: ['user', 'title', 'currentRoute']
};
</script>
