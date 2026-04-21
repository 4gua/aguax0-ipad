import SwiftUI
import WebKit

struct ReactPrototypeView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.userContentController.addUserScript(
            WKUserScript(
                source: "window.AGUA_NATIVE_IOS = true;",
                injectionTime: .atDocumentStart,
                forMainFrameOnly: true
            )
        )

        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.scrollView.backgroundColor = .black
        webView.scrollView.bounces = false

        context.coordinator.loadInitialContent(in: webView)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
    }

    final class Coordinator: NSObject, WKNavigationDelegate {
        private var hasLoadedFallback = false

        func loadInitialContent(in webView: WKWebView) {
            if let devURL = URL(string: "http://127.0.0.1:5173/") {
                let request = URLRequest(
                    url: devURL,
                    cachePolicy: .reloadIgnoringLocalCacheData,
                    timeoutInterval: 2.5
                )
                webView.load(request)
            } else {
                loadBundledPrototype(in: webView)
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            loadBundledPrototype(in: webView)
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            loadBundledPrototype(in: webView)
        }

        private func loadBundledPrototype(in webView: WKWebView) {
            guard !hasLoadedFallback else { return }
            hasLoadedFallback = true

            guard
                let indexURL = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "Prototype"),
                let prototypeDirectory = Optional(indexURL.deletingLastPathComponent())
            else {
                webView.loadHTMLString(
                    """
                    <html>
                    <body style="margin:0;background:#050302;color:#f0e6d2;font-family:-apple-system;">
                      <div style="height:100vh;display:flex;align-items:center;justify-content:center;text-align:center;padding:32px;">
                        React prototype bundle not found.
                      </div>
                    </body>
                    </html>
                    """,
                    baseURL: nil
                )
                return
            }

            webView.loadFileURL(indexURL, allowingReadAccessTo: prototypeDirectory)
        }
    }
}
