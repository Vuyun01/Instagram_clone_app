import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/model/post.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/service/post_service.dart';
import 'package:instagram_clone/service/user_services.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/model/user.dart' as um;
import 'package:instagram_clone/utils/user_constant.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // String keyword='';
  bool _isSearchUser = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final inputBorder =
        OutlineInputBorder(borderRadius: BorderRadius.circular(15));
    return Scaffold(
        appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            title: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal:
                      size.width > mobileScreenSize ? size.width * 0.25 : 0),
              child: TextField(
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      _isSearchUser = true;
                    });
                  } else {
                    setState(() {
                      _isSearchUser = false;
                    });
                  }
                },
                // onChanged: (value){
                //   keyword = value;
                //   setState(() {

                //   });
                // },
                cursorColor: Colors.grey.shade400,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    hintText: 'Search for an user',
                    border: InputBorder.none,
                    enabledBorder: inputBorder,
                    focusedBorder: inputBorder,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade400,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade800),
                controller: _searchController,
              ),
            )),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal:
                  size.width > mobileScreenSize ? size.width * 0.25 : 0),
          child: _isSearchUser
              ? FutureBuilder(
                  future: UserService().searchUsersByKeyword(
                      keyword: _searchController.text.trim()),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    final docs = snapshot.data!.docs;
                    print(docs.length);
                    return docs.isNotEmpty
                        ? ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context, index) {
                              final user = um.User.fromJson(docs[index].data());
                              return ListTile(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      ProfileScreen.routeName,
                                      arguments:
                                          docs[index].data()[UserConstant.uid]);
                                },
                                leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.avatar!)),
                                title: Text(user.username),
                              );
                            })
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: const ListTile(
                              title: Text(
                                'No user is found',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          );
                  })
              : FutureBuilder(
                  future: PostService().fetchPosts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                    final docs = snapshot.data!.docs;
                    return docs.isNotEmpty
                        ? SingleChildScrollView(
                            child: StaggeredGrid.count(
                              axisDirection: AxisDirection.down,
                              crossAxisCount: 2,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              children: List.generate(docs.length, (index) {
                                final post = Post.fromJson(docs[index].data());
                                return StaggeredGridTile.fit(
                                  // crossAxisCellCount: (index % 7 == 0) ? 2 : 1,
                                  crossAxisCellCount: 1,

                                  // mainAxisCellCount: (index % 7 == 0) ? 2 : 1,
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          post.postUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                );
                              }),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            child: const ListTile(
                              title: Text(
                                'No posts are available',
                                style: TextStyle(
                                    color: Colors.white54,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          );
                  }),
        ));
  }
}
