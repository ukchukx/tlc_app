<template>
  <b-navbar sticky toggleable="md">
    <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>

    <b-navbar-brand href="/">X</b-navbar-brand>

    <b-collapse is-nav id="nav_collapse">
      <!-- Right aligned nav items -->
      <b-navbar-nav class="ml-auto">
        <b-nav-item-dropdown right>
          <template slot="button-content">
          <span> <fa-icon icon="user" /> {{ user.first_name }}</span>
        </template>
          <b-dropdown-item href="/signout">Signout</b-dropdown-item>
        </b-nav-item-dropdown>
      </b-navbar-nav>

    </b-collapse>
  </b-navbar>
</template>

<script>
export default {
  name: 'TopBar',
  props: ['user']
};
</script>
