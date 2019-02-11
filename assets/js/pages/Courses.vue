<template>
  <StaffPage :user="user" title="Courses" current-route="courses">
    <div class="row">
      <div class="col text-center mx-auto">
        <flash-message />
      </div>
    </div>
    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
          Courses &emsp;
          <button @click="createCourse()" class="btn btn-sm btn-primary">Add course</button>
        </h6>
      </div>
      <div class="card-body">
        <div class="table-responsive">
          <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th>S/N</th>
                <th>Code</th>
                <th>Name</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(course, idx) in localCourses" :key="course.id">
                <td>{{ idx + 1 }}</td>
                <td>{{ course.code }}</td>
                <td>{{ course.name }}</td>
                <td>
                  <a :href="courseUrl(course)" class="btn btn-sm btn-link">
                    <fa-icon icon="arrow-right" /> Schedules
                  </a>
                  <button @click="editCourse(course)" class="btn btn-sm btn-outline-primary">
                    <fa-icon icon="pen" />
                  </button>
                  <button @click="deleteCourse(course)" class="btn btn-sm btn-outline-danger">
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
                  <label>Code</label>
                  <b-form-input v-model.trim="course.code" placeholder="Code"/>
                </div>
                <div class="form-group">
                  <label>Name</label>
                  <b-form-input v-model.trim="course.name" placeholder="Name"/>
                </div>
              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-outline-default"
                  @click.stop="closeModal()"
                >Close</button>
                <button
                  :disabled="!formOk"
                  type="button"
                  class="btn btn-primary"
                  @click.stop="saveCourse()"
                >Save</button>
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

const emptyCourse = {
  name: '',
  code: '',
  id: 0
};

export default {
  name: 'Courses',
  mixins: [Flash],
  components: {
    StaffPage
  },
  props: ['courses', 'user'],
  data() {
    return {
      localCourses: this.courses,
      course: { ...emptyCourse }
    };
  },
  computed: {
    modalTitle() {
      return this.course.id ? 'Update course' : 'Create course';
    },
    nameOk() {
      return this.course.name.length &&
        this.localCourses
          .filter(({ id }) => id !== this.course.id)
          .every(({ name }) => name !== this.course.name);
    },
    codeOk() {
      return this.course.code.length &&
        this.localCourses
          .filter(({ id }) => id !== this.course.id)
          .every(({ code }) => this.course.code !== code);
    },
    formOk() {
      return this.nameOk && this.codeOk;
    }
  },
  watch: {
    'course.code'(val) {
      if (typeof val === 'string') this.course.code = val.toUpperCase();
    }
  },
  methods: {
    courseUrl({ id }) {
      return `/bo/courses/${id}`;
    },
    saveCourse() {
      if (this.course.id) {
        axios
          .put(`/bo/courses/${this.course.id}`, {course: this.course })
          .then(({ data: { success, data } }) => {
            if (success) {
              const idx = this.localCourses.findIndex(({ id }) => id == this.course.id);
              this.localCourses.splice(idx, 1, data);
              this.closeModal();
              this.showFlash('Course updated', 'success');
            } else {
              this.showFlash('Could not update course', 'error');
            }
          })
          .catch(({ response: { data } }) => {
            console.log("error", data);
            this.showFlash('Could not update course', 'error');
          });
      } else {
        axios
          .post('/bo/courses', { course: this.course })
          .then(({ data: { success, data } }) => {
            if (success) {
              this.localCourses.push(data);
              this.closeModal();
              this.showFlash('Course created', 'success');
            } else {
              this.showFlash('Could not create course', 'error');
            }
          })
          .catch(({ response: { data } }) => {
            console.log("error", data);
            this.showFlash('Could not create course', 'error');
          });
      }
    },
    createCourse() {
      this.course = { ...emptyCourse };
      this.showModal();
    },
    editCourse(course) {
      this.course = Object.assign(this.course, course);
      this.showModal();
    },
    deleteCourse(course) {
      axios
        .delete(`/bo/courses/${course.id}`)
        .then(({ data: { success } }) => {
          if (success) {
            this.showFlash('Course deleted', 'success');
            this.localCourses = this.localCourses.filter(({ id }) => id !== course.id);
          } else {
            this.showFlash('Could not delete course', 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log("error", data);
          this.showFlash('Could not delete course', 'error');
        });
    },
    showModal() {
      this.modalOpen = true;
      $(this.$refs.modal).modal({ backdrop: 'static', keyboard: false });
    },
    closeModal() {
      this.modalOpen = false;
      $(this.$refs.modal).modal('hide');
    }
  }
}
</script>
