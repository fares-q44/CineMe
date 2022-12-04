import 'package:cineme/models/movie.dart';
import 'package:cineme/providers/search.dart';
import 'package:cineme/screens/movie_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> result = [];
  bool _isLoading = false;

  void search(String searchKey) {
    setState(() {
      _isLoading = true;
    });
    Provider.of<Search>(context, listen: false)
        .searchMovies(searchKey)
        .then((value) {
      result = value as List<Movie>;
      setState(() {
        _isLoading = false;
      });
    });
  }

  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    textController.dispose();
    super.dispose();
  }

  FocusNode textFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          child: TextField(
            onEditingComplete: () {
              FocusManager.instance.primaryFocus!.unfocus();
              search(textController.text);
            },
            textDirection: TextDirection.ltr,
            controller: textController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  FocusManager.instance.primaryFocus!.unfocus();
                  search(textController.text);
                },
              ),
              fillColor: Colors.white,
              filled: true,
              hintText: 'Movies search',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        if (result.isNotEmpty)
          Expanded(
            child: Center(
              child: GridView.builder(
                shrinkWrap: true,
                itemCount: result.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 1,
                  crossAxisSpacing: 1,
                  crossAxisCount: 2,
                ),
                itemBuilder: (ctx, index) => GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MovieDetailsScreen(
                        result[index],
                      ),
                    ),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    width: 200,
                    height: 150,
                    margin: EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            result[index].poster,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 3,
                          left: 150,
                          child: Container(
                            child: Text(
                              result[index].rate.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 3,
                          left: 127,
                          child: Container(
                            height: 18,
                            width: 18,
                            child: Image.asset('assets/icons/star.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
