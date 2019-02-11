<template>
  <StaffPage :user="user" title="Course schedule">
    <div class="row">
      <div class="col text-center mx-auto">
        <flash-message/>
      </div>
    </div>
    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
          ({{ course.code}}) {{ course.name }} &emsp;
          <button
            @click="showModal()"
            class="btn btn-sm btn-primary"
          >Add schedule</button>
        </h6>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th>S/N</th>
                <th>Stream</th>
                <th>Date</th>
                <th>Start</th>
                <th>End</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(s, idx) in localSchedules" :key="s.id">
                <td>{{ idx + 1 }}</td>
                <td>{{ s | streamName(streams) }}</td>
                <td>{{ s | scheduleDate }}</td>
                <td>{{ s | scheduleStart }}</td>
                <td>{{ s | scheduleEnd }}</td>
                <td>
                  <button @click="deleteSchedule(s)" class="btn btn-sm btn-outline-danger">
                    <fa-icon icon="trash" />
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <div
          ref="modal"
          class="modal fade"
          id="courseModal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="courseModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="courseModalLabel">{{ modalTitle }}</h5>
                <button type="button" class="close" @click.stop="closeModal()" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <div class="form-group">
                  <label>Stream</label>
                  <select v-model="stream" class="form-control">
                    <option
                      v-for="stream in streams"
                      :value="stream.id"
                      :key="stream.id"
                    >{{ stream.name }}</option>
                  </select>
                </div>
                <b-form-group label="Type">
                  <b-form-radio-group v-model="selectedType" :options="typeOptions"/>
                </b-form-group>
                <b-form-group label="Day" v-if="isRange">
                  <b-form-radio-group v-model="selectedDay" :options="dayOptions"/>
                </b-form-group>
                <div v-if="isRange">
                  <b-form-group label="Date range">
                    <div class="row">
                      <div class="col-sm-4">
                        <datetime
                          type="date"
                          zone="Africa/Lagos"
                          value-zone="Africa/Lagos"
                          v-model="startDate"
                          :min-datetime="minDate"
                        />
                      </div>
                      <div class="col-sm-1">
                        <h6>to</h6>
                      </div>
                      <div class="col-sm-4">
                        <datetime
                          type="date"
                          zone="Africa/Lagos"
                          value-zone="Africa/Lagos"
                          v-model="endDate"
                          :min-datetime="startDate"
                        />
                      </div>
                    </div>
                  </b-form-group>
                </div>
                <div v-else>
                  <b-form-group label="Date">
                    <div class="row">
                      <div class="col-sm-4">
                        <datetime
                          type="date"
                          zone="Africa/Lagos"
                          value-zone="Africa/Lagos"
                          v-model="startDate"
                          :min-datetime="minDate"
                        />
                      </div>
                    </div>
                  </b-form-group>
                </div>

                <b-form-group label="Time">
                  <div class="row">
                    <div class="col-sm-4">
                      <datetime
                        :use12-hour="true"
                        zone="Africa/Lagos"
                        value-zone="Africa/Lagos"
                        :minute-step="15"
                        type="time"
                        v-model="startTime"
                      />
                    </div>
                    <div class="col-sm-1">
                      <h6>to</h6>
                    </div>
                    <div class="col-sm-4">
                      <datetime
                        :use12-hour="true"
                        zone="Africa/Lagos"
                        value-zone="Africa/Lagos"
                        :minute-step="15"
                        type="time"
                        v-model="endTime"
                      />
                    </div>
                  </div>
                </b-form-group>
              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-outline-default"
                  @click.stop="closeModal()"
                >Close</button>
                <button type="button" class="btn btn-primary" @click.stop="createSchedule()">Add</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </StaffPage>
</template>

<script>
import axios from 'axios';
import StaffPage from '@/components/StaffPage';
import Flash from '@/mixins/Flash';
import Filters from '@/mixins/Filters';
import dateGenerator from '@/utils/dateGenerator';

export default {
  name: 'Course',
  mixins: [Flash, Filters],
  components: {
    StaffPage
  },
  props: ['course', 'user', 'streams'],
  data() {
    const now = new Date();

    return {
      localSchedules: this.course.schedules,
      minDate: now.toISOString(),
      startDate: now.toISOString(),
      endDate: now.toISOString(),
      startTime: now.toISOString(),
      endTime: now.toISOString(),
      selectedDay: 'Mon',
      stream: 1,
      dayOptions: [
        { text: 'Monday', value: 'Mon' },
        { text: 'Tuesday', value: 'Tue' },
        { text: 'Wednesday', value: 'Wed' },
        { text: 'Thursday', value: 'Thu' },
        { text: 'Friday', value: 'Fri' },
        { text: 'Saturday', value: 'Sat' },
        { text: 'Sunday', value: 'Sun' }
      ],
      selectedType: 'Range',
      typeOptions: [
        { text: 'Single', value: 'Single' },
        { text: 'Range', value: 'Range' }
      ],
    };
  },
  computed: {
    modalTitle() {
      return 'Add schedule';
    },
    isSingle() {
      return this.selectedType === 'Single';
    },
    isRange() {
      return this.selectedType === 'Range';
    },
    formOk() {
      return true;
    }
  },
  created() {
    this.localSchedules.sort((a, b) => a.start_time - b.start_time);
  },
  methods: {
    createSchedule() {
      if (this.isSingle) {
        this.endDate = this.startDate;
        this.selectedDay = new Date(this.startDate).toString().split(' ')[0];
      }

      const schedules = [...dateGenerator({
        selectedDays: [this.selectedDay],
        end: new Date(this.endDate),
        start: new Date(this.startDate)
        })
      ]
      .map((date) => {
        const start = new Date(this.startTime);
        const end = new Date(this.endTime);
        const startTime = new Date(date);
        const endTime = new Date(date);

        startTime.setHours(start.getHours(), start.getMinutes(), 0, 0);
        endTime.setHours(end.getHours(), end.getMinutes(), 0, 0);

        return {
          start_date: startTime.getTime(),
          end_date: endTime.getTime(),
          course_id: this.course.id,
          stream: this.stream
        };
      });

      axios
        .post(`/bo/courses/${this.course.id}/schedules`, { schedules })
        .then(({ data: { success, data } }) => {
          if (success) {
            this.localSchedules = data;
            this.localSchedules.sort((a, b) => a.start_time - b.start_time);
            this.closeModal();
            const msg = data.length > 1 ? 'Schedules' : 'Schedule';
            this.showFlash(`${msg} added`, 'success');
          } else {
            this.showFlash('Could not add schedules', 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log("error", data);
          this.showFlash('Could not add schedules', 'error');
        });
    },
    deleteSchedule({ id }) {
      axios
        .delete(`/bo/schedules/${id}`)
        .then(({ data: { success } }) => {
          if (success) {
            this.showFlash('Schedule removed', 'success');
            this.localSchedules = this.localSchedules.filter(s => id !== s.id);
          } else {
            this.showFlash('Could not remove schedule', 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log("error", data);
          this.showFlash('Could not remove schedule', 'error');
        });
    },
    showModal() {
      $(this.$refs.modal).modal({ backdrop: 'static', keyboard: false });
    },
    closeModal() {
      this.reset();
      $(this.$refs.modal).modal('hide');
    },
    reset() {
      this.minDate = new Date().toISOString();
      this.startDate = new Date().toISOString();
      this.endDate = new Date().toISOString();
      this.selectedDay = 'Mon';
      this.stream = 1;
      this.selectedType = 'Range';
    }
  }
}
</script>
