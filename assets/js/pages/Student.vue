<template>
  <Page :user="user" title="Student" current-route="student">
    <div class="row">
      <div class="col-sm-12">
        <div class="card shadow mb-4">
          <a href="#collapseCardExample" class="d-block card-header py-3" data-toggle="collapse" role="button" aria-expanded="true" aria-controls="collapseCardExample">
            <h6 class="m-0 font-weight-bold text-primary">Courses</h6>
          </a>
          <div class="collapse show" id="collapseCardExample" style="">
            <div class="card-body">
              <div v-for="c in courseRegs" :key="c.id" class="card bg-primary text-white shadow">
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
import Page from '@/components/Page';
import Flash from '@/mixins/Flash';
import Filters from '@/mixins/Filters';

export default {
  name: 'Student',
  mixins: [Flash, Filters],
  components: {
    Page
  },
  props: ['user', 'courseRegs', 'courses'],
  data() {
    return {
      streams: [
        { id: 1, name: 'Stream 1'},
        { id: 2, name: 'Stream 2' }
      ]
    };
  },
  methods: {

  }
}
</script>
