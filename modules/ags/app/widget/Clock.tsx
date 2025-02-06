import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { bind, Binding, GLib, interval, Variable } from 'astal';

// const AccurateTime = (): Variable<string> => {
//   let i = 500;
//   const increasingNumber = () => {
//     return (i += 500);
//   };
//   const timeOnCreate = GLib.DateTime.new_now_local();

//   // // Time until next second
//   // const syncTarget =
//   //   1000 -
//   //   parseInt(timeOnCreate.get_seconds().toString().split('.')[1].slice(0, 3));

//   // console.log('syncing in', syncTarget);
//   const pollingFn = () => {
//     console.log('polling');
//     return GLib.DateTime.new_now_local().format('%H:%M')!;
//   };

//   const time = Variable(timeOnCreate.format('%H:%M')!).poll(
//     increasingNumber(),
//     () => {

//       return pollingFn();

//       // if (!init) {
//       //   init = true;
//       //   return timeOnCreate.format('%H:%M')!;
//       // }
//       // time.stopPoll();
//       // const newTime = GLib.DateTime.new_now_local();
//       // const newSyncTarget =
//       //   1000 -
//       //   parseInt(
//       //     timeOnCreate.get_seconds().toString().split('.')[1].slice(0, 3)
//       //   );
//       // time.poll(newSyncTarget, () => {
//       // };
//       // console.log('syncing');
//     }
//   );

//   return time;
// };

const Clock = () => {
  const time = Variable<string>('').poll(
    1000,
    () => GLib.DateTime.new_now_local().format('%H:%M')!
  );
  return (
    <label
      className="Clock"
      onDestroy={() => time.drop()}
      label={time()}
    />
  );
};
export default Clock;
