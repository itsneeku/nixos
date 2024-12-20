import {
  App,
  Variable,
  Astal,
  Gtk,
  Gdk,
  GLib,
  bind,
  monitorFile,
  readFileAsync,
  readFile,
  Gio,
} from "astal";
import Hyprland from "gi://AstalHyprland";
import Mpris from "gi://AstalMpris";
import Battery from "gi://AstalBattery";
import Wp from "gi://AstalWp";
import Network from "gi://AstalNetwork";
import Tray from "gi://AstalTray";

function SysTray() {
  const tray = Tray.get_default();

  return (
    <box>
      {bind(tray, "items").as((items) =>
        items.map((item) => {
          if (item.iconThemePath) App.add_icons(item.iconThemePath);

          const menu = item.create_menu();

          return (
            <button
              tooltipMarkup={bind(item, "tooltipMarkup")}
              onDestroy={() => menu?.destroy()}
              onClickRelease={(self) => {
                menu?.popup_at_widget(
                  self,
                  Gdk.Gravity.SOUTH,
                  Gdk.Gravity.NORTH,
                  null
                );
              }}
            >
              <icon gIcon={bind(item, "gicon")} />
            </button>
          );
        })
      )}
    </box>
  );
}

// function Wifi() {
//   const { wifi } = Network.get_default();

//   return (
//     <icon
//       tooltipText={bind(wifi, "ssid").as(String)}
//       className="Wifi"
//       icon={bind(wifi, "iconName")}
//     />
//   );
// }

// function AudioSlider() {
//   const speaker = Wp.get_default()?.audio.defaultSpeaker!;

//   return (
//     <box className="AudioSlider" css="min-width: 140px">
//       <icon icon={bind(speaker, "volumeIcon")} />
//       <slider
//         hexpand
//         onDragged={({ value }) => (speaker.volume = value)}
//         value={bind(speaker, "volume")}
//       />
//     </box>
//   );
// }

const BatteryLevel = () => {
  const batteryPath = "/sys/class/power_supply/BAT1/capacity";

  const bat = Variable<string>(readFile(batteryPath));
  monitorFile(batteryPath, async (f) => {
    const v = await readFileAsync(batteryPath);
    bat.set(v);
  });

  return (
    <box className="Battery">
      {/* <icon icon={bind(bat, "batteryIconName")} /> */}
      <label label={bind(bat).as((p) => p)} />
    </box>
  );
};

const Workspaces = () => {
  const hypr = Hyprland.get_default();

  return (
    <box className="Workspaces">
      {bind(hypr, "workspaces").as((wss) =>
        wss
          .sort((a, b) => a.id - b.id)
          .filter((workspace) => workspace.id != -99)
          .map((workspace) => (
            <button
              className={bind(hypr, "focusedWorkspace").as((focusedWorkspace) =>
                workspace === focusedWorkspace ? "focused" : ""
              )}
              onClicked={() => workspace.focus()}
            >
              
            </button>
          ))
      )}
    </box>
  );
};

export const time = Variable<string>("").poll(
  1000,
  () => GLib.DateTime.new_now_local().format("%H:%M")!
);

function Time() {
  return (
    <label className="Time" onDestroy={() => time.drop()} label={time()} />
  );
}

export const Bar = (monitor: Gdk.Monitor) => {
  const anchor =
    Astal.WindowAnchor.TOP | Astal.WindowAnchor.LEFT | Astal.WindowAnchor.RIGHT;

  return (
    <window
      className="Bar"
      gdkmonitor={monitor}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      anchor={anchor}
    >
      <centerbox>
        <box hexpand halign={Gtk.Align.START}>
          <Workspaces />
          {/* <FocusedClient /> */}
        </box>
        <box>{/* <Media /> */}</box>
        <box hexpand halign={Gtk.Align.END}>
          <SysTray />
          {/* <Wifi /> */}
          {/* <AudioSlider /> */}
          <BatteryLevel />
          <Time />
        </box>
      </centerbox>
    </window>
  );
};
