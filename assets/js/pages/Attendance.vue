<template>
  <!-- eslint-disable -->
  <Page :user="user" title="Attendances">
    <div class="row">
      <div class="col text-center mx-auto">
        <flash-message/>
      </div>
    </div>
    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
          {{ currentDiet }} attendance list
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
              <tr v-for="(s, idx) in schedules" :key="s.id">
                <td>{{ idx + 1 }}</td>
                <td>{{ s | streamName(streams) }}</td>
                <td>{{ s | scheduleDate }}</td>
                <td>{{ s | scheduleStart }}</td>
                <td>{{ s | scheduleEnd }}</td>
                <td>
                  <button @click="download(s)" class="btn btn-primary btn-icon-split btn-sm">
                    <span class="icon text-white-50">
                      <fa-icon icon="file-download" />
                    </span>
                    <span class="text">Download <fa-icon v-if="busyId === s.id" icon="spinner" spin /> </span>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
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
  name: 'Attendance',
  components: {
    Page
  },
  mixins: [Flash, Filters],
  props: {
    schedules: {
      type: Array,
      default: () => []
    },
    user: {
      type: Object,
      default: () => {}
    },
    courses: {
      type: Array,
      default: () => []
    }
  },
  data() {
    const now = new Date();
    const month = now.getMonth() <= 4 ? 'May' : 'November';
    const currentDiet = `${month}, ${now.getFullYear()}`;

    return {
      currentDiet,
      streams: [
        { id: 1, name: 'Stream 1' },
        { id: 2, name: 'Stream 2' }
      ],
      busyId: 0
    };
  },
  created() {
    this.schedules.sort((a, b) => a.start_time - b.start_time);
  },
  methods: {
    download(s) {
      this.busyId = s.id;

      axios({
        url: `/bo/attendance/download/${s.id}`,
        method: 'get',
        responseType: 'blob'
      }).then((response) => {
        const url = window.URL.createObjectURL(new Blob([response.data]));
        const link = document.createElement('a');
        link.href = url;
        link.setAttribute('download', this.getFileName(s));
        document.body.appendChild(link);
        link.click();
        this.busyId = 0;
      }).catch(() => {
        this.busyId = 0;
      });
    },
    getFileName(s) {
      const { streamName, scheduleDate, courseName } = this.$options.filters;
      const course = courseName(s.course_id, this.courses).replace(/[^A-Z0-9]+/ig, '_');
      const stream = streamName(s, this.streams).replace(/[^A-Z0-9]+/ig, '_');
      const date = scheduleDate(s).replace(/[^A-Z0-9]+/ig, '_');
      const diet = s.diet.replace(/[^A-Z0-9]+/ig, '_');

      return `${diet}_${course}_${stream}_${date}.xlsx`.replace('__', '_');
    }
  }
};
</script>
