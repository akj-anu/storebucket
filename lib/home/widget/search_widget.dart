import 'package:flutter/material.dart';
import 'package:storebucket/home/home.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      color: Colors.grey[850],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          const Spacer(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                width: size.width * .4,
                child: TextFormField(
                    style: const TextStyle(color: Colors.white),
                    /*controller: _searchController,*/
                    maxLines: 1,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: const OutlineInputBorder(
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
                        hintStyle: const TextStyle(color: Colors.white)),
                    onChanged: (text) {
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
          ),
        ],
      ),
    );
  }
}
