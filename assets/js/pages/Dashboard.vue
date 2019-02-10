<template>
  <StaffPage :user="user">
    <div class="card mb3">
      <div class="card-header">
        Dashboard
      </div>
      <div class="card-body">
        Welcome
      </div>
    </div>
  </StaffPage>
</template>

<script>
import StaffPage from '@/components/StaffPage';

export default {
  name: 'Dashboard',
  components: {
    StaffPage
  },
  props: ['user']
}
</script>
