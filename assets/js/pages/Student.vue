<template>
  <!-- eslint-disable -->
  <Page :user="user" title="Student" current-route="student">
    <div class="row">
      <div class="col-sm-12 col-md-2 offset-md-10">
        <div v-if="!withinLectureArea" class="card bg-danger text-white shadow mb-3">
          <div class="card-body">
            Outside lecture area
            <div class="small">Attendance can only be marked within the lecture area</div>
          </div>
        </div>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-12 text-center mx-auto">
        <flash-message/>
      </div>
    </div>
    <div class="row">
      <div class="col-sm-12">
        <div class="card shadow mb-4">
          <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">Your ongoing classes <small>{{ lat }}, {{ long }}</small></h6>
          </div>
          <div class="card-body">
            <h3 v-if="!ongoingSchedules.length">No ongoing classes</h3>
            <div v-for="s in ongoingSchedules" :key="s.id" class="row mb-3">
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
                <button v-if="withinLectureArea" @click="mark(s)" class="btn btn-success btn-icon-split">
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
              <div v-for="c in localCourseRegs" :key="c.id" class="card shadow mb-3">
                <div class="card-body">
                  <div class="row">
                    <div class="col-sm-12 mb-3">
                      {{ c.course_id | courseName(courses) }}&ensp;|&ensp;{{ c | streamName(streams)}}
                      &emsp;
                      <button @click="show(c.id)" class="btn btn-light btn-icon-split btn-sm">
                        <span class="icon text-gray-600">
                          <fa-icon v-if="showing === c.id" icon="arrow-down" />
                          <fa-icon v-else icon="arrow-right" />
                        </span>
                        <span v-if="showing !== c.id" class="text">Show timetable</span>
                        <span v-else class="text">Hide timetable</span>
                      </button>
                    </div>
                  </div>

                  <div v-if="showing === c.id" class="table-responsive">
                    <table class="table table-striped table-condensed" id="dataTable" width="100%" cellspacing="0">
                      <thead>
                        <tr>
                          <th>Date</th>
                          <th>Start</th>
                          <th>End</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="s in c.schedules" :key="s.id">
                          <td>{{ s | scheduleDate }}</td>
                          <td>{{ s | scheduleStart }}</td>
                          <td>{{ s | scheduleEnd }}</td>
                        </tr>
                      </tbody>
                    </table>
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
import Location from '@/mixins/Location';

export default {
  name: 'Student',
  components: {
    Page
  },
  mixins: [Flash, Filters, Location],
  props: {
    user: {
      type: Object,
      default: () => {}
    },
    courses: {
      type: Array,
      default: () => []
    },
    schedules: {
      type: Array,
      default: () => []
    },
    courseRegs: {
      type: Array,
      default: () => []
    }
  },
  data() {
    return {
      streams: [
        { id: 1, name: 'Stream 1' },
        { id: 2, name: 'Stream 2' }
      ],
      ongoingSchedules: this.schedules,
      localCourseRegs: [],
      showing: 0,
      lat: 0,
      long: 0
    };
  },
  created() {
    this.localCourseRegs = this.courseRegs.map((c) => {
      const { schedules } = this.courses.find(({ id }) => id === c.course_id);
      return Object.assign(c, { schedules });
    });
  },
  methods: {
    mark(schedule) {
      const attendance = { schedule_id: schedule.id, user_id: this.user.id };
      axios
        .post('/sign-attendance', { attendance })
        .then(({ data: { success, data, message } }) => {
          if (success) {
            this.ongoingSchedules = data;
            this.showFlash(message, 'success');
          } else {
            this.showFlash(message, 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log('error', data);
          this.showFlash('Could not mark attendance', 'error');
        });
    },
    show(id) {
      // If this is already showing, hide, else show
      this.showing = this.showing === id ? 0 : id;
    }
  }
};
</script>
