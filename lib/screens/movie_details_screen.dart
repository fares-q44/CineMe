import 'package:cineme/models/movie.dart';
import 'package:cineme/providers/watchlist.dart';
import 'package:cineme/providers/youtube_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen(this.movie, {Key? key}) : super(key: key);

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  String videoUrl = '';
  late YoutubePlayerController _controller;

  Future<void> setVideo(String title) async {
    String videoId = await Provider.of<YoutubeProvider>(context, listen: false)
        .getVideo('$title trailer');
    videoUrl = 'https://www.youtube.com/watch?v=$videoId';

    final vedioID = YoutubePlayer.convertUrlToId(videoUrl);

    _controller = YoutubePlayerController(
        initialVideoId: vedioID!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
        ));
  }

  bool videoShown = false;
  bool loadingUrl = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF22264C),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Stack(
                    children: [
                      Image.network(
                        widget.movie.poster,
                        width: 400,
                      ),
                    ],
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xFF22264C),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 480,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: widget.movie.title,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                TextSpan(
                                    text:
                                        '   ( ${widget.movie.releaseDate.substring(0, 4)} )',
                                    style: TextStyle(fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 13),
                          width: double.infinity,
                          height: 30,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) => Row(
                              children: [
                                Chip(
                                  label: Text(widget.movie.genres[i]),
                                ),
                                SizedBox(
                                  width: 8,
                                )
                              ],
                            ),
                            itemCount: widget.movie.genres.length,
                          ),
                        )
                      ],
                    ),
                    height: 600,
                    width: 400,
                  ),
                  Positioned(
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: Text(
                      'Movie trailer',
                      style: TextStyle(color: Colors.white, fontSize: 26),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    height: 220,
                    child: FutureBuilder(
                      future: setVideo(widget.movie.title),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/timer.png',
                        width: 45,
                        height: 45,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      const Text(
                        '120 Minutes',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/icons/star.png',
                        width: 45,
                        height: 45,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        '${widget.movie.rate} / 10',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        '${widget.movie.rateCount.toString()} Reviews',
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            widget.movie.isWatchlist =
                                !widget.movie.isWatchlist;
                          });
                          Provider.of<Watchlist>(context, listen: false)
                              .toggleWatchlist(widget.movie);
                        },
                        color: Colors.yellow,
                        icon: Icon(
                          size: 40,
                          Provider.of<Watchlist>(context)
                                  .isInWatch(widget.movie.id)
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                        ),
                      ),
                      Text(
                        'Watchlist',
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 13,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 2),
                        ),
                        width: 170,
                        height: 240,
                        child: Image.network(
                          widget.movie.poster,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Title: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              TextSpan(
                                text: widget.movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  overflow: TextOverflow.fade,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Release Date: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                                text: widget.movie.releaseDate,
                                style: const TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Status: ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextSpan(
                                text: 'Released',
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      'Storyline',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.movie.overview,
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
