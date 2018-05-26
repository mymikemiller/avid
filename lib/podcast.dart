import 'package:feedparser/feedparser.dart';

class Podcast {
  final String title;
  final String imageUrl;
  final FeedItem latestEpisode;

  Podcast({this.title, this.imageUrl, this.latestEpisode});

  factory Podcast.fromFeed(feed) {
    return new Podcast(
      title: feed.title,
      imageUrl: feed.image.url,
      latestEpisode: feed.items[0]
    );
  }
}