import SwiftUI
import WebKit

struct EmbeddedModelViewer: UIViewRepresentable {
    let mode: VehicleMode

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false

        loadViewer(into: webView, mode: mode)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let modeString = mode == .driving ? "driving" : "parked"
        webView.evaluateJavaScript("window.setVehicleMode && window.setVehicleMode('\(modeString)');")
    }

    private func loadViewer(into webView: WKWebView, mode: VehicleMode) {
        guard
            let scriptURL = Bundle.main.url(forResource: "model-viewer.min", withExtension: "js"),
            let modelURL = Bundle.main.url(forResource: "honda_fit", withExtension: "glb")
        else {
            webView.loadHTMLString(
                """
                <html><body style="margin:0;background:transparent;color:white;font-family:-apple-system">
                <div style="display:flex;height:100%;align-items:center;justify-content:center;opacity:0.75;">3D assets unavailable</div>
                </body></html>
                """,
                baseURL: nil
            )
            return
        }

        let modeString = mode == .driving ? "driving" : "parked"
        let html = """
        <!doctype html>
        <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
          <script src="\(scriptURL.absoluteString)"></script>
          <style>
            html, body {
              margin: 0;
              width: 100%;
              height: 100%;
              overflow: hidden;
              background: transparent;
            }
            body {
              display: flex;
              align-items: center;
              justify-content: center;
            }
            model-viewer {
              width: 100%;
              height: 100%;
              background: transparent;
              --progress-bar-color: rgba(201,169,97,0.95);
              --poster-color: transparent;
            }
          </style>
        </head>
        <body>
          <model-viewer
            id="car"
            src="\(modelURL.absoluteString)"
            camera-controls
            disable-pan
            disable-zoom
            interaction-prompt="none"
            touch-action="pan-y"
            auto-rotate
            shadow-intensity="1.1"
            shadow-softness="0.8"
            exposure="1.15"
            environment-image="neutral"
            camera-target="auto auto auto"
            field-of-view="26deg"
            min-field-of-view="22deg"
            max-field-of-view="30deg"
            style="background: transparent;">
          </model-viewer>

          <script>
            const car = document.getElementById('car');

            function setVehicleMode(mode) {
              if (!car) return;

              if (mode === 'driving') {
                car.setAttribute('camera-orbit', '-18deg 76deg 86%');
                car.setAttribute('rotation-per-second', '26deg');
                car.setAttribute('exposure', '1.2');
              } else {
                car.setAttribute('camera-orbit', '28deg 74deg 82%');
                car.setAttribute('rotation-per-second', '10deg');
                car.setAttribute('exposure', '1.12');
              }
            }

            window.setVehicleMode = setVehicleMode;
            setVehicleMode('\(modeString)');
          </script>
        </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
}
