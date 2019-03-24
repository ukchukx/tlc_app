<script>
class Bounds {
  constructor(opts) {
    // this.center = { latitude: 9.0652514, longitude: 7.4271755 }; // TLC
    this.center = { lat: 9.1582655, lng: 7.3132746 }; // House
    this.radius = 0.01; // 10m in Km
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
      withinLectureArea: false,
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
        this.lat = coords.latitude;
        this.long = coords.longitude;
        this.withinLectureArea = this.fence.inside(coords);
        console.info('inside?', this.withinLectureArea);
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
