import 'package:cineme/providers/movies.dart';
import 'package:cineme/widgets/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<Movies>(context);

    return movieProvider.isFetching
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: const [
                Category(' Popular'),
                Category(' Top Rated'),
                Category(' Trending Today'),
                Category(' Upcoming'),
              ],
            ),
          );
  }
}
