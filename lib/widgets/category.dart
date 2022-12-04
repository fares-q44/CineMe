import 'package:cineme/models/movie.dart';
import 'package:cineme/providers/movies.dart';
import 'package:cineme/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Category extends StatefulWidget {
  final String title;

  const Category(this.title, {Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  bool isLoadingNextPage = false;
  void getNextPage() async {
    setState(() {
      isLoadingNextPage = true;
    });
    if (widget.title == ' Popular') {
      await Provider.of<Movies>(context, listen: false)
          .fetchAndSetPopularMovies();
    } else if (widget.title == ' Top Rated') {
      await Provider.of<Movies>(context, listen: false)
          .fetchAndSettopRatedMovies();
    } else if (widget.title == ' Trending Today') {
      await Provider.of<Movies>(context, listen: false)
          .fetchAndSetTrendingMovies();
    } else if (widget.title == ' Upcoming') {
      await Provider.of<Movies>(context, listen: false)
          .fetchAndSetUpcomingMovies();
    }
    setState(() {
      isLoadingNextPage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Movie> categoryList = [];
    if (widget.title == ' Popular') {
      categoryList =
          Provider.of<Movies>(context, listen: false).popularMovieList;
    } else if (widget.title == ' Top Rated') {
      categoryList =
          Provider.of<Movies>(context, listen: false).topRatedMovieList;
    } else if (widget.title == ' Trending Today') {
      categoryList =
          Provider.of<Movies>(context, listen: false).trendingMovieList;
    } else if (widget.title == ' Upcoming') {
      categoryList =
          Provider.of<Movies>(context, listen: false).upcomingMovieList;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyle(color: Colors.white, fontSize: 20),
          textAlign: TextAlign.start,
        ),
        const Divider(
          color: Colors.grey,
          thickness: 2,
        ),
        Container(
          margin: EdgeInsets.only(bottom: 7),
          height: 230,
          width: double.infinity,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return index != categoryList.length
                  ? GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MovieDetailsScreen(
                            categoryList[index],
                          ),
                        ),
                      ),
                      child: Container(
                        width: 150,
                        height: 170,
                        margin: EdgeInsets.all(2),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FadeInImage(
                                image: NetworkImage(categoryList[index].poster),
                                placeholder: AssetImage(
                                  'assets/images/movie-placeholder.png',
                                ),
                              ),
                            ),
                            Positioned(
                              top: 3,
                              left: 115,
                              child: Text(
                                categoryList[index].rate.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            Positioned(
                              top: 3,
                              left: 95,
                              child: Container(
                                height: 18,
                                width: 18,
                                child: Image.asset('assets/icons/star.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : index == 60
                      ? Container()
                      : isLoadingNextPage
                          ? Center(
                              child: Container(
                                width: 40,
                                height: 40,
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: getNextPage,
                                  child: Column(
                                    children: const [
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        color: Colors.blue,
                                      ),
                                      Text(
                                        'Show more',
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
            },
            itemCount: categoryList.length + 1,
          ),
        ),
      ],
    );
  }
}
