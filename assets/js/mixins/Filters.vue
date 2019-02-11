<script>
import moment from 'moment';

export default {
  name: 'Filters',
  filters: {
    scheduleDate({ start_date }) {
      return moment(start_date).format('ddd, MMM Do YYYY');
    },
    scheduleStart({ start_date }) {
      return moment(start_date).format('hh:mm a');
    },
    scheduleEnd({ end_date }) {
      return moment(end_date).format('hh:mm a');
    },
    streamName({ stream }, streams) {
      const obj = streams.find(({ id }) => stream === id);
      return obj ? obj.name : stream;
    }
  }
};
</script>
