// Simplified version of:
// https://www.userchrome.org/what-is-userchrome-js.html#combinedloader
// Single fn userChrome.js loader to run the above defined runInWindow fn (no external scripts)
const { Services } = globalThis;
const validUrls =
    /^(chrome:(?!\/\/(?:global\/content\/commonDialog|browser\/content\/webext-panels)\.x?html)|about:(?!blank))/i;

class ConfigJS {
    constructor() {
        Services.obs.addObserver(this, "chrome-document-global-created", false);
    }

    observe(subject) {
        subject.addEventListener(
            "DOMContentLoaded",
            (event) => {
                const { defaultView: window } = event.originalTarget;
                if (validUrls.test(window.location.href) && window._gBrowser) {
                    runInWindow(window);
                }
            },
            { once: true }
        );
    }
}

if (!Services.appinfo.inSafeMode) {
    try {
        new ConfigJS();
    } catch (ex) {
        console.error("Failed to initialize ConfigJS:", ex);
    }
}
