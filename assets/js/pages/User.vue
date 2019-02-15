<template>
  <Page :user="authUser" title="Student courses">
    <div class="row">
      <div class="col text-center mx-auto">
        <flash-message/>
      </div>
    </div>
    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
          {{ user.first_name}} {{ user.last_name }} ({{ user.email }}) &emsp;
          <button
            @click="showModal()"
            class="btn btn-sm btn-primary"
          >Add course</button>
        </h6>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th>S/N</th>
                <th>Diet</th>
                <th>Stream</th>
                <th>Course</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(c, idx) in localCourseRegs" :key="c.id">
                <td>{{ idx + 1 }}</td>
                <td>{{ c.diet }}</td>
                <td>{{ c | streamName(streams) }}</td>
                <td>{{ c.course_id | courseName(courses) }}</td>
                <td>
                  <button v-if="c.diet === currentDiet" @click="deleteCourseReg(c)" class="btn btn-sm btn-outline-danger">
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
          id="userModal"
          tabindex="-1"
          role="dialog"
          aria-labelledby="userModalLabel"
          aria-hidden="true"
        >
          <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="userModalLabel">{{ modalTitle }}</h5>
                <button type="button" class="close" @click.stop="closeModal()" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <div class="form-group">
                  <label>Stream</label>
                  <select v-model="courseReg.stream" class="form-control">
                    <option
                      v-for="stream in streams"
                      :value="stream.id"
                      :key="stream.id"
                    >{{ stream.name }}</option>
                  </select>
                </div>
                <div class="form-group">
                  <label>Course</label>
                  <select v-model="courseReg.course_id" class="form-control">
                    <option value="0">Select course</option>
                    <option v-for="c in courses" :value="c.id" :key="c.id">{{ c.id | courseName(courses) }}</option>
                  </select>
                </div>
              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-outline-default"
                  @click.stop="closeModal()"
                >Close</button>
                <button :disabled="!formOk" type="button" class="btn btn-primary" @click.stop="createCourseReg()">Add</button>
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
  name: 'User',
  mixins: [Flash, Filters],
  components: {
    Page
  },
  props: ['authUser', 'user', 'courses', 'courseRegs'],
  data() {
    const today = new Date();
    const month = today.getMonth() <= 4 ? 'May' : 'November';
    const currentDiet = `${month}, ${today.getFullYear()}`;

    return {
      streams: [
        { id: 1, name: 'Stream 1' },
        { id: 2, name: 'Stream 2' }
      ],
      localCourseRegs: this.courseRegs,
      courseReg: {
        user_id: this.user.id,
        stream: 1,
        course_id: 0,
        diet: currentDiet
      },
      defaultCourseReg: {
        user_id: this.user.id,
        stream: 1,
        course_id: 0,
        diet: currentDiet
      },
      currentDiet
    };
  },
  computed: {
    modalTitle() {
      return `Add course to student for the ${this.currentDiet} diet`;
    },
    formOk() {
      const { course_id, diet, stream } = this.courseReg;
      return this.courseRegs
        .filter(cr => cr.stream === stream && cr.diet === diet && cr.course_id === course_id)
        .length === 0 && !!course_id;
    }
  },
  methods: {
    createCourseReg() {
      axios
        .post('/bo/users/register-course', { course_reg: this.courseReg })
        .then(({ data: { success, data } }) => {
          if (success) {
            this.localCourseRegs.push(data);
            this.closeModal();
            this.showFlash('Course added', 'success');
          } else {
            this.showFlash('Could not add course', 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log("error", data);
          this.showFlash('Could not add course', 'error');
        });
    },
    deleteCourseReg({ id }) {
      if (!confirm('Are you sure?')) return;

      axios
        .delete(`/bo/users/unregister-course/${id}`)
        .then(({ data: { success } }) => {
          if (success) {
            this.showFlash('Course removed', 'success');
            this.localCourseRegs = this.localCourseRegs.filter(s => id !== s.id);
          } else {
            this.showFlash('Could not remove course', 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log("error", data);
          this.showFlash('Could not remove course', 'error');
        });
    },
    showModal() {
      this.courseReg = { ...this.defaultCourseReg };
      $(this.$refs.modal).modal({ backdrop: 'static', keyboard: false });
    },
    closeModal() {
      $(this.$refs.modal).modal('hide');
    }
  }
}
</script>
