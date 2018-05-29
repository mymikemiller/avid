import 'package:feedparser/feedparser.dart';

class Podcast {
  final String feedUrl;
  final String title;
  final String imageUrl;
  final FeedItem latestEpisode;

  Podcast({this.feedUrl, this.title, this.imageUrl, this.latestEpisode});

  factory Podcast.fromFeed(feedUrl, feed) {
    return new Podcast(
      feedUrl: feedUrl,
      title: feed.title,
      imageUrl: feed.image.url,
      latestEpisode: feed.items[0]
    );
  }
}