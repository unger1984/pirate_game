import 'package:flame/components.dart';
import 'package:pirate/presentation/components/main/targets/star.dart';
import 'package:pirate/presentation/components/main/targets/stats_counter.dart';
import 'package:pirate/presentation/components/main/targets/stats_progress.dart';

class StatsComponent extends PositionComponent {
  final _bg = SpriteComponent();
  final _statsProgress = StatsProgress();
  final active = SpriteComponent();
  final counter = StatsCounter();
  final star1 = Star();
  final star2 = Star();
  final star3 = Star();
  late final double _max;

  int _scoreStar1 = 0;
  int _scoreStar2 = 0;
  int _scoreStar3 = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final bgSprite = await Sprite.load('png/stats_panel.png');
    _bg.sprite = bgSprite;
    _bg.size = bgSprite.srcSize;
    size = _bg.size;

    final activeSprite = await Sprite.load('png/progress_active.png');
    active.sprite = activeSprite;
    active.size = activeSprite.srcSize;
    _max = activeSprite.srcSize.x;

    await add(_bg);
    await add(_statsProgress);
    await add(active);
    await add(counter);

    await add(star1);
    await add(star2);
    await add(star3);

    _statsProgress.position = Vector2(20, 20);
    active.position = Vector2(25, 20);
    counter.position = Vector2(size.x - counter.size.x - 20, 20);
  }

  void init(int star1Val, int star2Val, int star3Val) {
    _scoreStar1 = star1Val;
    _scoreStar2 = star2Val;
    _scoreStar3 = star3Val;

    star3.position = Vector2(_max, 0);

    var score1X = _scoreStar1 * _max / _scoreStar3;
    star1.position = Vector2(score1X, 0);

    var score2X = _scoreStar2 * _max / _scoreStar3;
    star2.position = Vector2(score2X, 0);

    counter.count = 0;
    active.size.x = 0;
  }

  void addScore(int score) {
    counter.count += score;
    var current = counter.count;
    active.size.x = (current / _scoreStar3) * _max;
    if (current >= _scoreStar1 && !star1.active) star1.active = true;
    if (current >= _scoreStar2 && !star2.active) star2.active = true;
    if (current >= _scoreStar3 && !star3.active) star3.active = true;
  }
}
