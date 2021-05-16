import 'package:meta/meta.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:recipe_app_2/helpers/Constants.dart';

//me
const nickwu241 = User(name: 'kaying', imageUrl: 'assets/images/user_shape.png');

const grootlover = User(
    name: 'grootlover',
    imageUrl: 'assets/images/user_shape.png',
    );
const starlord = User(
    name: 'starlord',
    imageUrl: 'assets/images/user_shape.png',
    );
const gamora = User(
    name: 'gamora',
    imageUrl: 'assets/images/user_shape.png',
    );
const rocket = User(
    name: 'rocket',
    imageUrl: 'assets/images/user_shape.png',
    );
const nebula = User(
    name: 'nebula',
    imageUrl: 'assets/images/user_shape.png',
    );

const currentUser = nickwu241;

class Post {
  String imageUrls;
  final User user;
  final DateTime postedAt;

  List<Like> likes;
  //List<Comment> comments;
  String location;

  String timeAgo() {
    final now = DateTime.now();
    return timeago.format(now.subtract(now.difference(postedAt)));
  }

  bool isLikedBy(User user) {
    return likes.any((like) => like.user.name == user.name);
  }

  void addLikeIfUnlikedFor(User user) {
    if (!isLikedBy(user)) {
      likes.add(Like(user: user));
    }
  }

  void toggleLikeFor(User user) {
    if (isLikedBy(user)) {
      likes.removeWhere((like) => like.user.name == user.name);
    } else {
      addLikeIfUnlikedFor(user);
    }
  }

  Post({
    @required this.imageUrls,
    @required this.user,
    @required this.postedAt,
    @required this.likes,
    //@required this.comments,
    this.location,
  });
}

class User {
  final String name;

  final String imageUrl;
  //final List<Story> stories;

  const User({
    @required this.name,
    this.imageUrl,
    //this.stories = const <Story>[],
  });
}

class Comment {
  String text;
  //final User user;
  //final DateTime commentedAt;
  //List<Like> likes;
/*
  bool isLikedBy(User user) {
    return likes.any((like) => like.user.name == user.name);
  }

  void toggleLikeFor(User user) {
    if (isLikedBy(user)) {
      likes.removeWhere((like) => like.user.name == user.name);
    } else {
      likes.add(Like(user: user));
    }
  }
  */

  Comment({
    @required this.text,
    /*
    @required this.user,
    @required this.commentedAt,
    @required this.likes,
    */
  });
}

class Like {
  final User user;

  Like({@required this.user});
}

class Story {
  const Story();
}