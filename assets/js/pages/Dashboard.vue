<template>
  <StaffPage :user="user" title="Dashboard" current-route="dashboard">
    <div class="row">
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
          <div class="card-body">
            <div class="row no-gutters align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Courses</div>
                <div class="h5 mb-0 font-weight-bold text-gray-800">{{ courseCount }}</div>
              </div>
              <div class="col-auto">
                <fa-icon icon="file" class="fa-2x text-gray-300" />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
          <div class="card-body">
            <div class="row no-gutters align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Students (active)</div>
                <div class="h5 mb-0 font-weight-bold text-gray-800">{{ activeStudentCount }}</div>
              </div>
              <div class="col-auto">
                <fa-icon icon="file" class="fa-2x text-gray-300" />
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="col-xl-3 col-md-6 mb-4">
        <div class="card border-left-primary shadow h-100 py-2">
          <div class="card-body">
            <div class="row no-gutters align-items-center">
              <div class="col mr-2">
                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">Staff</div>
                <div class="h5 mb-0 font-weight-bold text-gray-800">{{ staffCount }}</div>
              </div>
              <div class="col-auto">
                <fa-icon icon="file" class="fa-2x text-gray-300" />
              </div>
            </div>
          </div>
        </div>
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
  props: ['user', 'courseCount', 'activeStudentCount', 'staffCount']
}
</script>
