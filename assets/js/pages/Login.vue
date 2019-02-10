<template>
  <div class="container">
    <div class="row">
      <div class="col-sm-8 text-center mx-auto">
        <flash-message />
      </div>
    </div>
    <div class="row justify-content-center mt-4">
      <div class="col-md-8">
        <div class="card card-default">
          <div class="card-body">
            <form method="post" :action="formPath">
              <input type="hidden" name="_csrf_token" v-model="form._csrf_token">
              <div class="form-group">
                <label>Email address</label>
                <input
                  class="form-control"
                  name="email"
                  type="email"
                  v-model.trim="form.email"
                  placeholder="Email address"
                >
              </div>
              <div class="form-group">
                <label>Password</label>
                <input
                  class="form-control"
                  name="password"
                  type="password"
                  v-model.trim="form.password"
                  placeholder="Password"
                >
              </div>
              <button class="btn btn-primary" type="submit">Login</button>
              <!--<a href="/forgot/password">Forgot password</a> -->
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Flash from '@/mixins/Flash';

export default {
  name: 'Login',
  mixins: [Flash],
  props: ['formPath', 'errorMessage'],
  data() {
    return {
      useAjax: true,
      form: {
        _csrf_token: '',
        email: '',
        password: ''
      }
    };
  },
  computed: {
    formFilled() {
      const { email, password } = this.form;
      return /^\w+\.*\w*@\w+\.\w+/.test(email) && password.length >= 6;
    }
  },
  mounted() {
    const el = document.querySelector('meta[name="csrf-token"]');
    if (el) this.form._csrf_token = el.content;
    if (this.errorMessage) {
      this.showFlash(this.errorMessage, 'error');
    }
  },
  methods: {
    doAuth() {
      if (!this.useAjax) {
        return true;
      }

      axios
        .post("/auth/login", this.form)
        .then(({ data }) => {
          console.log(data);
          if (!data.success) {
            alert(data.message);
            return;
          }
          window.location = "/choose-profile";
        })
        .catch(({ response: { data: { message } } }) => {
          alert(message);
        });
      return false;
    }
  }
};
</script>

