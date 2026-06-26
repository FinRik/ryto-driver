import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../app/res/icons.dart';
import '../../../../../core/models/vehicle_setup/vehicle_type_model.dart';
import '../../../../styles/app_decorations.dart';

class VehicleTypeListItem extends StatelessWidget {
  const VehicleTypeListItem({
    super.key,
    required this.isItemSelected,
    required this.listItem,
  });

  final bool isItemSelected;
  final VehicleTypeModel listItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: !isItemSelected
          ? AppDecoration.roundedOutlinedRadius8
          : AppDecoration.roundedOutlinedRadius8.copyWith(color: Color(0xff0060EB)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                listItem.image,
                color: isItemSelected ? Colors.white : Colors.black,
              ),

              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isItemSelected ? Colors.yellow : Colors.blue,
                  ),
                ),
                child: isItemSelected
                    ? Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          height: 14,
                          width: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.yellow,
                          ),
                        ),
                      )
                    : null,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                listItem.carType,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isItemSelected ? Colors.yellow : Colors.black,
                ),
              ),
              Text(
                listItem.catDesc,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: isItemSelected ? Colors.white : Color(0xff838794),
                ),
              ),
              // if(listItem.dispPrice != null)
              // // Text(
              // //   listItem.dispPrice!,
              // //   style: TextStyle(
              // //     fontSize: 14,
              // //     fontWeight: FontWeight.w700,
              // //     color: isItemSelected ? Colors.yellow : Colors.black,
              // //   ),
              // // ),
              // if(listItem.errorDesc != null)
              // Text(
              //   listItem.errorDesc!,
              //   style: TextStyle(
              //     fontSize: 10,
              //     fontWeight: FontWeight.w400,
              //     color: Colors.red,
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
