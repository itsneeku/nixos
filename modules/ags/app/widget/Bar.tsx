import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { Variable } from 'astal';
import Workspaces from './Workspaces';
import Clock from './Clock';
import Battery from './Battery';
import Audio from './Audio';

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;

  return (
    <window
      className="Bar"
      gdkmonitor={gdkmonitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={TOP | LEFT | RIGHT}
      application={App}
    >
      <centerbox>
        <Workspaces halign={Gtk.Align.START} />
        <box />
        <box
          className={`Tray Container`}
          halign={Gtk.Align.END}
        >
          <Audio />
          <Battery />
          <Clock />
        </box>
      </centerbox>
    </window>
  );
}
