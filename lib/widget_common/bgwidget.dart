import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:trash_talk/consts/consts.dart';


Widget bgWidget({Widget? child}){
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage(imgBackground),fit: BoxFit.fill),

    ),
    child:child,
  );
}

 Widget appScreenCommonBackground(BuildContext context) {
return Container(
height: MediaQuery
    .of(context)
    .size
    .height,
color: Color(0xFF212121),
alignment: Alignment.topCenter,
child: SingleChildScrollView(
physics: NeverScrollableScrollPhysics(),
child: Column(
mainAxisAlignment: MainAxisAlignment.start,
children: <Widget>[
  SvgPicture.asset(
    'assets/images/app_background_image.svg', // Replace 'assets/your_image.svg' with the path to your SVG image
  ),
],
),
),
);
}
 SliverAppBar transparentFlexibleSpace(BuildContext context) {
double h = MediaQuery
    .of(context)
    .size
    .height;
return SliverAppBar(
backgroundColor: Colors.transparent,
elevation: 0,
pinned: true,
stretch: true,
expandedHeight: 90,
collapsedHeight: 0,
flexibleSpace: const FlexibleSpaceBar(
stretchModes: [StretchMode.zoomBackground],
),
toolbarHeight: 0,
);
}

