<template>
  <div>
    <TopBar :user="user" />
    <div class="sb-wrapper">
      <Sidebar />
      <div id="content-wrapper">
        <div class="container-fluid">
          <slot />
        </div>
        <footer class="sticky-footer">
          <div class="container my-auto">
            <div class="copyright text-center my-auto">
              <span>Copyright © 2019</span>
            </div>
          </div>
        </footer>
      </div>
    </div>
  </div>
</template>
<script>
import TopBar from '@/components/TopBar';
import Sidebar from '@/components/Sidebar';

export default {
  name: 'StaffPage',
  components: {
    TopBar,
    Sidebar
  },
  props: ['user']
};
</script>
