<template>
  <ul class="sidebar navbar-nav">
    <li class="nav-item">
      <a class="nav-link" href="/">
        <i class="fas fa-fw fa-tachometer-alt"></i>
        <span>Dashboard</span>
      </a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="/bo/courses">
        <i class="fas fa-fw fa-chart-area"></i>
        <span>Courses</span></a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="/bo/settings">
        <i class="fas fa-fw fa-table"></i>
        <span>Settings</span></a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="/bo/attendance">
        <i class="fas fa-fw fa-table"></i>
        <span>Attendance</span></a>
    </li>
    <li class="nav-item">
      <a class="nav-link" href="/bo/users">
        <i class="fas fa-fw fa-table"></i>
        <span>Users</span></a>
    </li>
  </ul>
</template>

<script>
export default {
  name: 'Sidebar'
}
</script>
