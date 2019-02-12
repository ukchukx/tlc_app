<template>
  <Page :user="authUser" title="Users" current-route="users">
    <div class="row">
      <div class="col text-center mx-auto">
        <flash-message />
      </div>
    </div>
    <div class="card shadow mb-4">
      <div class="card-header py-3">
        <h6 class="m-0 font-weight-bold text-primary">
          Users &emsp;
          <button @click="createUser()" class="btn btn-sm btn-primary">Create student/staff</button>
        </h6>
      </div>
      <div class="card-body">
        <div class="row">
          <div class="col-md-4 col-sm-12">
            <div class="custom-file mb-4">
              <input
                @change="onFileInput"
                type="file"
                class="custom-file-input"
                accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet, application/vnd.ms-excel" >
              <label class="custom-file-label">Choose Excel file to upload students</label>
            </div>
          </div>
        </div>
        <div class="table-responsive">
          <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
            <thead>
              <tr>
                <th>S/N</th>
                <th>First name</th>
                <th>Last name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Active</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(u, idx) in localUsers" :key="u.id">
                <td>{{ idx + 1 }}</td>
                <td>{{ u.first_name }}</td>
                <td>{{ u.last_name }}</td>
                <td>{{ u.email }}</td>
                <td>{{ u.phone }}</td>
                <td>
                  <span class="badge badge-secondary">
                    {{ u.role }}
                  </span>
                </td>
                <td>
                  <span v-if="u.active" class="badge badge-info">Yes</span>
                  <span v-else class="badge badge-danger">No</span>
                </td>
                <td>
                  <a v-if="isStudent(u)" :href="userUrl(u)" class="btn btn-sm btn-link">
                    <fa-icon icon="arrow-right" /> Course registration
                  </a>
                  <button @click="editUser(u)" class="btn btn-sm btn-outline-primary">
                    <fa-icon icon="pen" />
                  </button>
                  <button @click="deleteUser(u)" class="btn btn-sm btn-outline-danger">
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
                  <label>First name</label>
                  <b-form-input v-model.trim="user.first_name" placeholder="First name"/>
                </div>
                <div class="form-group">
                  <label>Last name</label>
                  <b-form-input v-model.trim="user.last_name" placeholder="Last name"/>
                </div>
                <div class="form-group">
                  <label>Email</label>
                  <b-form-input v-model.trim="user.email" placeholder="Email"/>
                </div>
                <div class="form-group">
                  <label>Phone</label>
                  <b-form-input v-model.trim="user.phone" placeholder="Phone"/>
                </div>
                <div v-if="user.id" class="form-group">
                  <input type="checkbox" v-model="user.active" class="form-input-check">
                  <label>Active</label>
                </div>
                <div class="form-group">
                  <label>Role</label>
                  <select v-model="user.role" class="form-control">
                    <option value="student">Student</option>
                    <option value="staff">Staff</option>
                  </select>
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
                  @click.stop="saveUser()"
                >Save</button>
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
import XLSX from 'xlsx';
import Page from '@/components/Page';
import Flash from '@/mixins/Flash';

const emptyUser = {
  first_name: '',
  last_name: '',
  email: '',
  phone: '',
  role: 'student',
  id: 0
};

export default {
  name: 'Users',
  mixins: [Flash],
  components: {
    Page
  },
  props: ['users', 'authUser'],
  data() {
    return {
      localUsers: this.users,
      user: { ...emptyUser }
    };
  },
  computed: {
    modalTitle() {
      return this.user.id ? 'Update user' : 'Create user';
    },
    emailOk() {
      return /^\w+\.*\w*@\w+\.\w+/.test(this.user.email) &&
        this.localUsers
          .filter(({ id }) => id !== this.user.id)
          .every(({ email }) => email !== this.user.email);
    },
    phoneOk() {
      return /^\d{7,11}$/.test(this.user.phone) &&
        this.localUsers
          .filter(({ id }) => id !== this.user.id)
          .every(({ phone }) => phone !== this.user.phone);
    },
    formOk() {
      const { first_name, last_name } = this.user;
      return typeof first_name === 'string' &&
        typeof last_name === 'string' &&
        !!first_name.length &&
        !!last_name.length &&
        this.emailOk &&
        this.phoneOk;
    }
  },
  watch: {
    user: {
      deep: true,
      handler(val) {
        if (typeof val !== 'object' || !val) return;
        const { first_name, last_name } = this.user;
        if (typeof first_name === 'string') this.user.first_name = first_name.toUpperCase();
        if (typeof last_name === 'string') this.user.last_name = last_name.toUpperCase();
      }
    }
  },
  methods: {
    userUrl({ id }) {
      return `/bo/users/${id}`;
    },
    saveUser() {
      if (this.user.id) {
        axios
          .put(`/bo/users/${this.user.id}`, {user: this.user })
          .then(({ data: { success, data } }) => {
            if (success) {
              const idx = this.localUsers.findIndex(({ id }) => id == this.user.id);
              this.localUsers.splice(idx, 1, data);
              this.closeModal();
              this.showFlash('User updated', 'success');
            } else {
              this.showFlash('Could not update user', 'error');
            }
          })
          .catch(({ response: { data } }) => {
            console.log("error", data);
            this.showFlash('Could not update user', 'error');
          });
      } else {
        axios
          .post('/bo/users', { user: this.user })
          .then(({ data: { success, data } }) => {
            if (success) {
              this.localUsers.push(data);
              this.closeModal();
              this.showFlash('User created', 'success');
            } else {
              this.showFlash('Could not create user', 'error');
            }
          })
          .catch(({ response: { data } }) => {
            console.log("error", data);
            this.showFlash('Could not create user', 'error');
          });
      }
    },
    createUser() {
      this.user = { ...emptyUser };
      this.showModal();
    },
    editUser(user) {
      this.user = Object.assign(this.user, user);
      this.showModal();
    },
    deleteUser(user) {
      if (!confirm('Are you sure?')) return;

      axios
        .delete(`/bo/users/${user.id}`)
        .then(({ data: { success } }) => {
          if (success) {
            this.showFlash('User deleted', 'success');
            this.localUsers = this.localUsers.filter(({ id }) => id !== user.id);
          } else {
            this.showFlash('Could not delete user', 'error');
          }
        })
        .catch(({ response: { data } }) => {
          console.log("error", data);
          this.showFlash('Could not delete user', 'error');
        });
    },
    showModal() {
      $(this.$refs.modal).modal({ backdrop: 'static', keyboard: false });
    },
    closeModal() {
      $(this.$refs.modal).modal('hide');
    },
    isStudent({ role }) {
      return role === 'student';
    },
    onFileInput(e) {
      const files = e.target.files || e.dataTransfer.files;
      if (!files.length) return;
      const excelFile = files[0];

      const reader = new FileReader();
      reader.onload = (f) => {
        const role = 'student';
        const workbook = XLSX.read(f.target.result, { type: 'binary' });
        const data = XLSX.utils.sheet_to_json(workbook.Sheets[workbook.SheetNames[0]], { header: 1 });

        data
          .filter(([fn, ln, email, phone]) => this.localUsers.every(u => u.email !== email && u.phone !== phone))
          .forEach(([fn, ln, email, phone]) => {
            if (fn && fn.toLowerCase() !== 'first name') {
              phone = typeof phone === 'number' ? `0${phone}` : phone;
              const user = {
                first_name: fn,
                last_name: ln,
                email,
                phone,
                role
              };

              axios
                .post('/bo/users', { user })
                .then(({ data: { success, data } }) => {
                  if (success) {
                    this.localUsers.push(data);
                  }
                })
                .catch(({ response: { data } }) => {
                  console.log("error", data);
                });
            }
          });
      };
      reader.readAsBinaryString(excelFile);
    }
  }
}
</script>
