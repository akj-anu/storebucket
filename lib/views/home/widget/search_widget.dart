import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/provider/project_data_provider.dart';

class Search extends StatelessWidget {
  final double? width;
  final bool hideName;
  const Search({Key? key, this.width, required this.hideName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[850],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!hideName)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Hi , ${Home.username}',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          if (!hideName) const Spacer(),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
            width: width ?? size.width * .4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  /*controller: _searchController,*/
                  maxLines: 1,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      /*   suffixIcon: IconButton(
                          onPressed: () => _searchController
                              .text !=
                              ""
                              ? search()
                              : snackMsg(
                              text:
                              "Please Enter Search Contents",
                              color: Colors.orange),
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          )),*/
                      hintText: 'SEARCH',
                      hintStyle: TextStyle(color: Colors.white)),
                  onChanged: (text) {
                    if (text != '') {
                      context.read<ProjectDataProvider>().searchData(text);
                    } else {
                      context
                          .read<ProjectDataProvider>()
                          .updateSearchLoader(false);
                    }

                    /*    searchElement = text;
                    if (searchElement != "" ||
                        searchElement.isNotEmpty) {
                      search();
                    } else {
                      setState(() {
                        isDataAdded = true;
                        searchedData = null;
                        Home.searchDataList = null;
                        searchData = null;
                      });
                    }*/
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
