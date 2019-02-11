<template>
  <StaffPage :user="user">
    <div class="card mb3">
      <div class="card-header">
        Courses
        <button @click="createCourse()" class="btn btn-sm btn-outline-primary">Add course</button>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table">
            <thead>
              <tr>
                <th>Name</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="course in courses" :key="course.id">
                <td>{{ course.name }}</td>
                <td>
                  <div>
                    <a href="#" class="btn btn-sm btn-outline-default">Add schedule</a>
                    <a href="#" class="btn btn-sm btn-outline-default">Edit</a>
                    <a href="#" class="btn btn-sm btn-outline-danger">Delete</a>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </StaffPage>
</template>

<script>
import StaffPage from '@/components/StaffPage';

export default {
  name: 'Courses',
  components: {
    StaffPage
  },
  props: ['courses', 'user']
}
</script>
