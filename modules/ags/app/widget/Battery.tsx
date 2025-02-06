import { interval, Variable } from 'astal';
import Gio from 'gi://Gio';

import { monitorFile, readFile, readFileAsync } from 'astal/file';
import AstalBattery from 'gi://AstalBattery';
import { Astal } from 'astal/gtk3';

const formatTime = (seconds: number) =>
  `${Math.floor(seconds / 60 / 60)} h ${Math.floor((seconds / 60) % 60)} min`;

const Battery = () => {
  const bat = Variable(AstalBattery.get_default());

  const detailedView = Variable(false);

  interval(5 * 1000, () => bat.set(AstalBattery.get_default()));

  const batteryLabel = Variable.derive(
    [detailedView, bat],
    (detailedView, bat) => {
      const icon =
        bat.percentage >= 0.8
          ? ''
          : bat.percentage >= 0.6
          ? ''
          : bat.percentage >= 0.4
          ? ''
          : bat.percentage >= 0.2
          ? ''
          : '';
      return `${icon} ${
        detailedView ? `  ${Math.floor(bat.percentage * 100)}%` : ''
      }`;
    }
  );

  return (
    <eventbox onClick={(_) => detailedView.set(!detailedView.get())}>
      <label
        tooltipText={bat((bat) => {
          console.log('tooltip updated');
          return `${
            bat.state === AstalBattery.State.FULLY_CHARGED
              ? 'Plugged'
              : bat.state === AstalBattery.State.DISCHARGING
              ? `Time to empty: ${formatTime(bat.timeToEmpty)}`
              : `Time to full: ${formatTime(bat.timeToFull)}`
          }`;
        })}
        className={`Battery
          ${bat((bat) => (bat.charging ? 'Charging' : ''))}
          ${detailedView((v) => (v ? 'Detailed' : ''))}`}
        onDestroy={bat.drop}
        label={batteryLabel()}
      />
    </eventbox>
  );
};

export default Battery;
