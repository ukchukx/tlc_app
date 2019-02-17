<script>
class CircularGeofenceRegion {
  constructor(opts) {
    Object.assign(this, opts);
  }

  inside({ latitude, longitude }) {
    const R = 63710; // Earth's radius in m

    return Math.acos(Math.sin(this.latitude) * Math.sin(latitude) +
                     Math.cos(this.latitude) * Math.cos(latitude) *
                     Math.cos(longitude - this.longitude)) * R < this.radius;
  }
}

export default {
  name: 'Location',
  data() {
    return {
      withinLectureArea: false,
      fence: new CircularGeofenceRegion({
        name: 'TlcFence',
        latitude: 9.0652514,
        longitude: 7.4271755,
        radius: 15 // meters
      })
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
        enableHighAccuracy: false,
        maximumAge: 0
      }
    );
  }
};
</script>
