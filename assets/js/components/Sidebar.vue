<template>
  <ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="/">
      <div class="sidebar-brand-icon rotate-n-15">
        <fa-icon icon="laugh-wink" />
      </div>
      <div class="sidebar-brand-text mx-3">TLC App</div>
    </a>

    <!-- Divider -->
    <hr class="sidebar-divider my-0">

    <!-- Nav Item - Dashboard -->
    <li :class="getClasses('dashboard')">
      <a class="nav-link" href="/">
        <fa-icon icon="tachometer-alt"/>
        <span>Dashboard</span></a>
    </li>


    <!-- Nav Item - Charts -->
    <li :class="getClasses('courses')">
      <a class="nav-link" href="/bo/courses">
        <fa-icon icon="file"/>
        <span>Courses</span></a>
    </li>

    <!-- Nav Item - Tables -->
    <li :class="getClasses('tables')">
      <a class="nav-link" href="tables.html">
        <fa-icon icon="file" />
        <span>Tables</span></a>
    </li>

    <!-- Divider -->
    <hr class="sidebar-divider d-none d-md-block">

    <!-- Sidebar Toggler (Sidebar) -->
    <div class="text-center d-none d-md-inline">
      <button class="rounded-circle border-0" id="sidebarToggle">
      </button>
    </div>

  </ul>
</template>

<script>
export default {
  name: 'Sidebar',
  props: {
    currentRoute: {
      default: ''
    }
  },
  methods: {
    getClasses(route) {
      return route === this.currentRoute ? 'nav-item active' : 'nav-item';
    }
  }
}
</script>
