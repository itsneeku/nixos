import { App, Astal, Gtk, Gdk } from "astal";
import { WindowProps } from "astal/widgets";

export const getMonitorByModel = (model: string): Gdk.Monitor | undefined =>
  App.get_monitors().find((monitor) => monitor.model === model);

export const onAllMonitors = (
  component: () => any,
  ...params: WindowProps[]
): Gtk.Widget[] => {
  return App.get_monitors().map((monitor) => (
    <window {...params} gdkmonitor={monitor}></window>
  ));
};
