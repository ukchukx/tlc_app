<template>
  <Page :user="user" title="Student" current-route="student">
    <div class="row">
      <div class="col text-center mx-auto">
        <flash-message/>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-12">
        <div v-if="localSchedules.length" class="card shadow mb-4">
          <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Your ongoing classes</h6>
          </div>
          <div class="card-body">
            <div v-for="s in localSchedules" :key="s.id" class="row mb-3">
              <div class="col-sm-12 col-md-4">
                <div class="row mb-3">
                  <div class="col-sm-12">
                    <b>{{ s.course_id | courseName(courses) }}</b>
                  </div>
                  <div class="col-sm-12">
                    {{ s | scheduleStart }} to {{ s | scheduleEnd }}
                  </div>
                </div>
              </div>

              <div class="col-sm-12 col-md-4">
                <button @click="mark(s)" class="btn btn-success btn-icon-split">
                  <span class="icon text-white-50">
                    <fa-icon icon="check" />
                  </span>
                  <span class="text">Mark attendance</span>
                </button>
              </div>
            </div>
          </div>
        </div>

        <div class="card shadow mb-4">
          <a href="#collapseCardExample" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample">
            <h6 class="m-0 font-weight-bold text-primary">Your courses</h6>
          </a>
          <div class="collapse show" id="collapseCardExample" style="">
            <div class="card-body">
              <div v-for="c in courseRegs" :key="c.id" class="card bg-primary text-white shadow mb-3">
                <div class="card-body">
                  <div class="row">
                    <div class="col-sm-9">
                      {{ c.course_id | courseName(courses) }}
                    </div>
                    <div class="col-sm-3 text-right">
                      | {{ c | streamName(streams) }}
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </Page>
</template>

<script>
import axios from 'axios';
import Page from '@/components/Page';
import Flash from '@/mixins/Flash';
import Filters from '@/mixins/Filters';

export default {
  name: 'Student',
  mixins: [Flash, Filters],
  components: {
    Page
  },
  props: ['user', 'courseRegs', 'courses', 'schedules'],
  data() {
    return {
      streams: [
        { id: 1, name: 'Stream 1'},
        { id: 2, name: 'Stream 2' }
      ],
      localSchedules: this.schedules
    };
  },
  created() {
    this.localSchedules.sort((a, b) => a.start_time - b.start_time);
  },
  methods: {
    mark(schedule) {
      const attendance = { schedule_id: schedule.id, user_id: this.user.id };
      axios
        .post('/sign-attendance', { attendance })
        .then(({ data: { success, data, message } }) => {
          if (success) {
            this.localSchedules = data;
            this.localSchedules.sort((a, b) => a.start_time - b.start_time);
            this.showFlash(message, 'success');
          } else {
            this.showFlash(message, 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log("error", data);
          this.showFlash('Could not mark attendance', 'error');
        });
    }
  }
}
</script>
