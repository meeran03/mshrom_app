import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_ecommerce_app/helper/appbar.dart';
import 'package:many_vendor_ecommerce_app/helper/helper.dart';
import 'package:many_vendor_ecommerce_app/model/campaign.dart';
import 'package:many_vendor_ecommerce_app/provider/campaign_provider.dart';
import 'package:many_vendor_ecommerce_app/screen/single.campaign.screen.dart';
import 'package:provider/provider.dart';

class CampaignScreen extends StatefulWidget {
  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  List<CampaignData> campaignData;

  @override
  void initState() {
    setState(() {
      campaignData =
          Provider.of<CampaignProvider>(context, listen: false).getData();
    });
    statusCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 120) / 2;
    final double itemWidth = size.width / 2;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background.png'), fit: BoxFit.cover)),
        child: GridView.builder(
            itemCount: campaignData.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: itemWidth / itemHeight,
              crossAxisCount: 2,
            ),
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SingleCampaignScreen(
                                  campaignData: campaignData[index],
                                )));
                  },
                  child: Card(
                    elevation: elevation,
                    child: Container(
                        color: Colors.white,
                        margin: EdgeInsets.all(8),
                        width: size.width / 3.4,
                        height: size.height / 4,
                        child: CachedNetworkImage(
                          imageUrl: campaignData[index].banner,
                          fit: BoxFit.fill,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                                  child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(primaryColor),
                                      value: downloadProgress.progress)),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )),
                  ),
                )),
      ),
    ));
  }
}
