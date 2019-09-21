<template>
  <div />
</template>
<script>
class Bounds {
  constructor(opts) {
    this.center = { latitude: 9.0674029, longitude: 7.4283716 }; // TLC
    // this.center = { lat: 9.1582655, lng: 7.3132746 }; // Test
    /**
    Outside:
    { latitude: 9.0676665, longitude: 7.428519 }
    { latitude: 9.0673378, longitude: 7.4286539 }
    { latitude: 9.067164, longitude: 7.4286923 }
    Inside:
    { latitude: 9.0674762, longitude: 7.4282976 }
    { latitude: 9.0674029, longitude: 7.4283716 }
     */
    this.radius = 0.022; // 22m in Km
  }

  inside({ latitude, longitude }) { // Algo provided by https://stackoverflow.com/users/69083/guffa
    const ky = 40000 / 360; // KM per degree of latitude
    const kx = Math.cos(Math.PI * this.center.latitude / 180.0) * ky; // KM per degree of longitude
    const dx = Math.abs(this.center.longitude - longitude) * kx;
    const dy = Math.abs(this.center.latitude - latitude) * ky;

    return Math.sqrt(dx * dx + dy * dy) <= this.radius;
  }
}

export default {
  name: 'Location',
  data() {
    return {
      fence: new Bounds(),
      geoOptions: {
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      }
    };
  },
  mounted() {
    if (!navigator.geolocation) {
      this.showFlash('Attendance cannot be marked without location access', 'warning', { timeout: 20000 });
      return;
    }

    this.scheduleNextCall();
  },
  methods: {
    scheduleNextCall() {
      setTimeout(
        () => navigator.geolocation.getCurrentPosition(this.getLocation, this.errCallback, this.geoOptions),
        5000
      );
    },
    getLocation({ coords: { latitude, longitude } }) {
      console.info('current location', `${latitude}, ${longitude}`);

      this.$emit('location', { inside: this.fence.inside({ latitude, longitude }), latitude, longitude });

      this.scheduleNextCall();
    },
    errCallback(err) {
      console.error(err);
      this.withinLectureArea = false;
    }
  }
};
</script>
