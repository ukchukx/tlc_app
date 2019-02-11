<template>
  <StaffPage :user="user" title="Dashboard" current-route="dashboard">

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
