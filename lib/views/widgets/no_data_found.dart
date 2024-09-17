import 'package:flutter/material.dart';

class CommonNoDataWidget extends StatelessWidget {
 final String? image;
 final String? title;
 final String? subTitle;

  const CommonNoDataWidget({Key? key,this.title,this.image,this.subTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var s=MediaQuery.of(context).size;
    return SizedBox(
      width: s.width,
      height: s.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(image!=null)
            Image.network(image!),
            if(title!=null)
              const SizedBox(height: 20,),
            if(title!=null)
              Text(title!,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
            if(subTitle!=null)
              const SizedBox(height:6,),
            if(subTitle!=null)
              Text(subTitle!,style: const TextStyle(fontSize: 13,color: Colors.black38,),textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}
