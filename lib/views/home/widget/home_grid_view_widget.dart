import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:storebucket/common/extention.dart';
import 'package:storebucket/generated/assets.dart';
import 'package:storebucket/views/home/home.dart';
import 'package:storebucket/views/home/widget/details.dart';
import 'package:storebucket/provider/project_data_provider.dart';
import 'package:storebucket/utils/colors.dart';
import 'package:storebucket/views/home/widget/update_bottomsheet.dart';
import 'package:storebucket/views/widgets/common_success_failure_dailog.dart';
import 'package:storebucket/views/widgets/no_data_found.dart';
import 'package:tuple/tuple.dart';

class HomeGridView extends StatelessWidget {
  const HomeGridView({
    Key? key,
  }) : super(key: key);

  getCount(size) {
    if (size <= 500 || size > 500 && size <= 700) {
      return 1;
    } else if (size > 700 && size <= 1024) {
      return 2;
    } else if (size > 1024 && size <= 1300) {
      return 3;
    } else if (size > 1300) {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    print(size.width);
    return Selector<
            ProjectDataProvider,
            Tuple4<List<QueryDocumentSnapshot>, bool,
                List<QueryDocumentSnapshot>, bool>>(
        selector: (_, selector) => Tuple4(
            selector.projectList,
            selector.isLoading,
            selector.searchedDataList,
            selector.isSearching),
        builder: (_, data, __) {
          List<QueryDocumentSnapshot> dataList =
              data.item4 ? data.item3 : data.item1;

          return SizedBox(
            height: size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: data.item2
                      ? Center(
                          child: Lottie.network(
                            "https://assets10.lottiefiles.com/packages/lf20_RnSQsr.json",
                            width: 200,
                            height: 200,
                          ),
                        )
                      : data.item1.isEmpty
                          ? const CommonNoDataWidget(
                              image: Assets.iconsNoSearchData,
                              title: "No Projects Found",
                              subTitle:
                                  "Currently no projects added yet.Be you are the first one to add a project and continue.",
                            )
                          : (data.item4 && data.item3.isEmpty)
                              ? const CommonNoDataWidget(
                                  image: Assets.iconsNoSearchData,
                                  title: "Searched Data Not Found",
                                  subTitle:
                                      "It seems that you have searched item not found!.Search again.",
                                )
                              : SizedBox(
                                  child: GridView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: dataList.length,
                                    cacheExtent: 99999,
                                    itemBuilder: (_, i) {
                                      return Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsScreen(
                                                  code: dataList[i]['code'],
                                                  title: dataList[i]['title'],
                                                  description: dataList[i]
                                                      ['description'],
                                                  username: dataList[i]['name'],
                                                ),
                                              ));
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: getColors(dataList[
                                                                            i][
                                                                        'name'] !=
                                                                    ""
                                                                ? dataList[i][
                                                                        'name'][0]
                                                                    .toString()
                                                                    .toUpperCase()
                                                                : "U"),
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              dataList[i]['name'] !=
                                                                      ""
                                                                  ? dataList[i][
                                                                      'name'][0]
                                                                  : "U",
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                child: Text(dataList[i]['name'] !=
                                                                            ""
                                                                        ? dataList[i]
                                                                            [
                                                                            'name']
                                                                        : "User")
                                                                    .avoidOverFlow(),
                                                              ),
                                                              const Text(
                                                                  "@hi,very cool"),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      dataList[i]['title']
                                                          .toString()
                                                          .camelCase(),
                                                      maxLines: 1,
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      dataList[i]
                                                          ['description'],
                                                      style: const TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 13),
                                                    ).avoidOverFlow(
                                                      maxLine: 2,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (Home.username ==
                                              dataList[i]['name'])
                                            Positioned(
                                                right: 5,
                                                top: 10,
                                                child: Center(
                                                  child: PopupMenuButton(
                                                      iconSize: 20,
                                                      itemBuilder:
                                                          (context) => <
                                                                  PopupMenuItem<
                                                                      String>>[
                                                                PopupMenuItem<
                                                                        String>(
                                                                    child: Row(
                                                                      children: const [
                                                                        Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.blue,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              7,
                                                                        ),
                                                                        Text(
                                                                            'Edit'),
                                                                      ],
                                                                    ),
                                                                    value:
                                                                        'edit'),
                                                                PopupMenuItem<
                                                                        String>(
                                                                    child: Row(
                                                                      children: const [
                                                                        Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              7,
                                                                        ),
                                                                        Text(
                                                                            'Delete'),
                                                                      ],
                                                                    ),

                                                                    value:
                                                                        'delete'),
                                                              ],
                                                  onSelected: (key){
                                                        if(key=="edit"){
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) => UpdateBottomSheet(
                                                                  title: dataList[i]['title'] ?? '',
                                                                                description: dataList[i]['description'] ?? '',
                                                                                code: dataList[i]['code'] ?? ''

                                                                ),
                                                              ));
                                                        }else if(key=="delete"){
                                                          context
                                                              .read<
                                                              ProjectDataProvider>()
                                                              .delete(
                                                              i,
                                                              dataList[i].id)
                                                              .then((value) {
                                                            print(
                                                                "Value $value");
                                                            if (value) {
                                                              CommonAlertDialog.showDialogPopUp(
                                                                  context,
                                                                  title: "Success",
                                                                  lottieImage: Assets.lottieFilesSuccess,
                                                                  subTitle: "Document deleted",
                                                                  titleColor: Colors.green);
                                                            } else {
                                                              CommonAlertDialog.showDialogPopUp(
                                                                  context,
                                                                  title: "Failed",
                                                                  lottieImage: Assets.lottieFilesFail,
                                                                  subTitle: "Failed to delete!.Try again",
                                                                  titleColor: Colors.red);
                                                            }
                                                          });
                                                        }
                                                  },
                                                  ),
                                                ))
                                        ],
                                      );
                                    },
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount:
                                                getCount(size.width),
                                            mainAxisSpacing: 15,
                                            crossAxisSpacing: 15,
                                            childAspectRatio: size.width > 700
                                                ? 230 / 190
                                                : size.width > 500
                                                    ? 230 / 130
                                                    : 230 / 70),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                  ),
                                ),
                ),
              ],
            ),
          );
        });
  }
}

Color getColors(String name) {
  Color color = Colors.red;
  avatarColors.forEach((key, value) {
    if (key == name) {
      color = value;
    }
  });
  return color;
}
