import 'package:e_wallet/models/tip_model.dart';
import 'package:e_wallet/shared/theme.dart';
import 'package:e_wallet/ui/pages/tip_detail_page.dart';
import 'package:flutter/material.dart';

class HomeTipsItem extends StatelessWidget {
  final TipModel tip;

  const HomeTipsItem({
    super.key,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 72) / 2; // 24 padding left + 24 right + 24 gap = 72

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TipDetailPage(
                title: tip.title.toString(),
                url: tip.url.toString(),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: itemWidth,
          height: 176,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  tip.thumbnail.toString(),
                  width: double.infinity,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 110,
                      color: lightBackgroundColor,
                      child: Icon(
                        Icons.image_not_supported,
                        color: greyColor,
                        size: 40,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: double.infinity,
                      height: 110,
                      color: lightBackgroundColor,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: primaryColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  tip.title.toString(),
                  style: blackTextStyle.copyWith(
                    fontWeight: medium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
