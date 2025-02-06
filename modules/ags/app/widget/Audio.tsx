import { interval, Variable } from 'astal';
import Gio from 'gi://Gio';

import { monitorFile, readFile, readFileAsync } from 'astal/file';
import Wp from 'gi://AstalWp';
import { Astal } from 'astal/gtk3';

const Audio = () => {
  const audio = Variable(Wp.get_default());

  const audioLabel = Variable.derive([audio], (audio) => {
    const volume = audio?.audio.defaultSpeaker.volume!;
    let icon;
    if (volume >= 0.8) {
      icon = '';
    } else if (volume >= 0.6) {
      icon = '';
    } else {
      icon = '';
    }

    return `${icon}`;
  });

  return (
    <eventbox onClick={(_) => print('clicked')}>
      <label
        className={`Audio`}
        onDestroy={audio.drop}
        label={audioLabel()}
      />
    </eventbox>
  );
};

export default Audio;
