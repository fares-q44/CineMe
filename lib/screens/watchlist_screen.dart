import 'package:cineme/providers/watchlist.dart';
import 'package:cineme/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  List watchlist = [];

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<Watchlist>(context);
    watchlist = Provider.of<Watchlist>(context).watchlistMovies;
    return movieProvider.isFetching
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : watchlist.isEmpty
            ? const Center(
                child: Text(
                  'No movies in watchlist',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MovieDetailsScreen(
                          watchlist[index],
                        ),
                      ),
                    ),
                    child: Card(
                      color: Colors.blueGrey,
                      elevation: 4,
                      margin: EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.all(4),
                            width: 90,
                            height: 120,
                            child: Image.network(
                              watchlist[index].poster,
                              fit: BoxFit.contain,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${watchlist[index].title}  ' +
                                    '( ${watchlist[index].releaseDate.substring(0, 4)} )',
                                style: TextStyle(color: Colors.white),
                              ),
                              Container(
                                child: Divider(
                                  color: Colors.black,
                                ),
                                width: 250,
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.yellow,
                                  ),
                                  Text(
                                    watchlist[index].rate,
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              Container(
                                child: Divider(
                                  color: Colors.black,
                                ),
                                height: 20,
                                width: 250,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                style: TextStyle(color: Colors.white),
                                watchlist[index]
                                    .genres
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", ""),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: watchlist.length,
              );
  }
}
