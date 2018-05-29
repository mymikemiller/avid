import 'package:feedparser/feedparser.dart';
import 'package:xml/xml.dart' as xml;

class Podcast {
  final String feedUrl;
  final String title;
  final String category;
  final String imageUrl;
  final FeedItem latestEpisode;

  Podcast({this.feedUrl, this.title, this.category, this.imageUrl, this.latestEpisode});

  factory Podcast.fromXml(feedUrl, xmlString) {
    Feed feed = parse(xmlString);

    var document = xml.parse(xmlString);
    
    // Get the category by parsing the xml (it's not accessible in the Feed)
    var channelElement = document.rootElement.findElements("channel").first;
    var categoryElement = channelElement.findElements("itunes:category").first;
    var category = categoryElement.getAttribute("text");

    return new Podcast(
      feedUrl: feedUrl,
      title: feed.title,
      category: category,
      imageUrl: feed.image.url,
      latestEpisode: feed.items[0]
    );
  }
}