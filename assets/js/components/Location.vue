<template>
  <div />
</template>
<script>
class Bounds {
  constructor(opts) {
    this.center = { latitude: 9.0674029, longitude: 7.4283716 }; // TLC
    // this.center = { latitude: 9.0014854, longitude: 7.4542722 }; // AppMart
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
    this.radius = 0.02; // 20m in Km
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
      fence: new Bounds()
    };
  },
  mounted() {
    if (!navigator.geolocation) {
      this.showFlash('Attendance cannot be marked without location access', 'warning', { timeout: 20000 });
      return;
    }

    navigator.geolocation.watchPosition(
      ({ coords }) => {
        console.log(coords);
        const { latitude, longitude } = coords;
        const inside = this.fence.inside({ latitude, longitude });

        this.$emit('location', { inside, latitude, longitude });
      },
      (err) => {
        console.error(err);
        this.withinLectureArea = false;
      }, {
        enableHighAccuracy: true,
        maximumAge: 0
      }
    );
  }
};
</script>
