<template>
  <!-- eslint-disable -->
  <nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">
    <!-- Sidebar Toggle (Topbar) -->
    <button v-if="isStaff" id="sidebarToggleTop" class="btn btn-link rounded-circle mr-3">
      <fa-icon icon="bars" />
    </button>

    <!-- Topbar Navbar -->
    <ul class="navbar-nav ml-auto">
      <div class="topbar-divider d-none d-sm-block"></div>

      <!-- Nav Item - User Information -->
      <li class="nav-item dropdown no-arrow">
        <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
          <span class="mr-2 text-gray-600 small">{{ user.first_name }} {{ user.last_name }}</span>
        </a>
        <!-- Dropdown - User Information -->
        <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in" aria-labelledby="userDropdown">
          <a class="dropdown-item" href="#">
            <fa-icon icon="user" class="fa-sm fa-fw mr-2 text-gray-400" />
            Profile
          </a>
          <div class="dropdown-divider"></div>
          <a class="dropdown-item" href="/signout">
            <fa-icon icon="sign-out-alt" class="fa-sm fa-fw mr-2 text-gray-400" />
            Logout
          </a>
        </div>
      </li>
    </ul>
  </nav>
</template>

<script>
export default {
  name: 'TopBar',
  props: {
    user: {
      type: Object,
      default: () => {}
    }
  },
  computed: {
    isStaff() {
      return this.user.role === 'staff';
    }
  }
};
</script>
