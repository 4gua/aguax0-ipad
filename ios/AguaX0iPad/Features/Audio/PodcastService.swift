import Foundation

struct PodcastEpisode: Identifiable {
    let id = UUID()
    let title: String
    let show: String
    let duration: String
    let audioURL: String
    let pubDate: String
}

struct PodcastFeed {
    let name: String
    let rssURL: String
}

class PodcastService: ObservableObject {
    @Published var episodes: [PodcastEpisode] = []
    @Published var isLoading = false

    let feeds: [PodcastFeed] = [
        PodcastFeed(name: "CyberWire Daily",
                    rssURL: "https://feeds.megaphone.fm/cyberwire-daily-podcast"),
        PodcastFeed(name: "Cybersecurity Today",
                    rssURL: "https://feeds.buzzsprout.com/1409696.rss"),
        PodcastFeed(name: "Darknet Diaries",
                    rssURL: "https://feeds.megaphone.fm/darknetdiaries"),
    ]

    func fetchAll() {
        isLoading = true
        episodes = []
        let group = DispatchGroup()

        for feed in feeds {
            group.enter()
            fetchFeed(feed) { newEpisodes in
                DispatchQueue.main.async {
                    self.episodes.append(contentsOf: newEpisodes)
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.isLoading = false
        }
    }

    private func fetchFeed(_ feed: PodcastFeed, completion: @escaping ([PodcastEpisode]) -> Void) {
        guard let url = URL(string: feed.rssURL) else {
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { completion([]); return }
            let parser = RSSParser(feedName: feed.name, data: data)
            completion(parser.parse())
        }.resume()
    }
}

class RSSParser: NSObject, XMLParserDelegate {
    private let feedName: String
    private let data: Data
    private var episodes: [PodcastEpisode] = []

    private var currentTitle = ""
    private var currentDuration = ""
    private var currentAudioURL = ""
    private var currentPubDate = ""
    private var currentElement = ""
    private var inItem = false

    init(feedName: String, data: Data) {
        self.feedName = feedName
        self.data = data
    }

    func parse() -> [PodcastEpisode] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return Array(episodes.prefix(3))
    }

    func parser(_ parser: XMLParser, didStartElement element: String, namespaceURI: String?, qualifiedName: String?, attributes: [String: String] = [:]) {
        currentElement = element
        if element == "item" { inItem = true }
        if element == "enclosure", let url = attributes["url"] {
            currentAudioURL = url
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let s = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !s.isEmpty, inItem else { return }
        switch currentElement {
        case "title":       currentTitle    += s
        case "itunes:duration": currentDuration += s
        case "pubDate":     currentPubDate  += s
        default: break
        }
    }

    func parser(_ parser: XMLParser, didEndElement element: String, namespaceURI: String?, qualifiedName: String?) {
        if element == "item" {
            if !currentTitle.isEmpty {
                episodes.append(PodcastEpisode(
                    title: currentTitle,
                    show: feedName,
                    duration: formatDuration(currentDuration),
                    audioURL: currentAudioURL,
                    pubDate: formatDate(currentPubDate)
                ))
            }
            currentTitle = ""
            currentDuration = ""
            currentAudioURL = ""
            currentPubDate = ""
            inItem = false
        }
    }

    private func formatDuration(_ raw: String) -> String {
        if raw.contains(":") { return raw }
        if let seconds = Int(raw) {
            let m = seconds / 60
            let h = m / 60
            return h > 0 ? "\(h)h \(m % 60)m" : "\(m)m"
        }
        return raw.isEmpty ? "—" : raw
    }

    private func formatDate(_ raw: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
        if let date = formatter.date(from: raw) {
            let out = DateFormatter()
            out.dateFormat = "MMM d"
            return out.string(from: date)
        }
        return raw
    }
}
