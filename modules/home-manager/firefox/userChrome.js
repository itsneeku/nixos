function runInWindow(win) {
    // Switch tabs with Alt + Mouse Wheel
    win.document.addEventListener(
        "wheel",
        (event) => {
            if (event.altKey) {
                event.preventDefault();
                const delta = event.deltaY > 0 ? 1 : event.deltaY < 0 ? -1 : 0;
                if (delta)
                    win.gBrowser.tabContainer.advanceSelectedTab(delta, true);
            }
        },
        true
    );

    // win.document.addEventListener("keydown", (event) => {
    //     if (event.altKey && event.key === "") {
    //         event.preventDefault();
    //         win.gBrowser.tabContainer.advanceSelectedTab(
    //             event.shiftKey ? -1 : 1,
    //             true
    //         );
    //     }
    // });

    win.document.addEventListener(
        "keydown",
        (event) => {
            if (event.altKey && !event.shiftKey) {
                switch (event.key) {
                    case "ArrowLeft":
                        event.preventDefault();
                        win.gBrowser.tabContainer.advanceSelectedTab(-1, true);
                        break;
                    case "ArrowRight":
                        event.preventDefault();
                        win.gBrowser.tabContainer.advanceSelectedTab(1, true);
                        break;
                }
            }
        },
        true
    );
}
