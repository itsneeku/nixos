import { App, Astal, Gtk, Gdk } from 'astal/gtk3';
import { bind } from 'astal';
import Hyprland from 'gi://AstalHyprland';

const Workspaces = () => {
  const hypr = Hyprland.get_default();

  return (
    <box className="Workspaces Container">
      {bind(hypr, 'workspaces').as((workspaces) =>
        workspaces
          .filter((workspace) => !(workspace.id >= -99 && workspace.id <= -2)) // filter out special workspaces
          .sort((a, b) => a.id - b.id)
          .map((workspace) => (
            <button
              className={bind(hypr, 'focusedWorkspace').as(
                (focusedWorkspace) =>
                  `workspace ${
                    workspace === focusedWorkspace ? 'focusedWorkspace' : ''
                  }`
              )}
              onClick={() => workspace.focus()}
              // onKeyPressEvent={() => workspace.focus()}
              // label=""
            >
              
            </button>
          ))
      )}
    </box>
  );
};
export default Workspaces;
