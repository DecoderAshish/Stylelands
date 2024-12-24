import 'package:cutfx/bloc/choosestaff/manage_staff_bloc.dart';
import 'package:cutfx/model/staff/staff.dart';
import 'package:cutfx/utils/app_res.dart';
import 'package:cutfx/utils/asset_res.dart';
import 'package:cutfx/utils/color_res.dart';
import 'package:cutfx/utils/const_res.dart';
import 'package:cutfx/utils/custom/custom_widget.dart';
import 'package:cutfx/utils/style_res.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ChooseBarberScreen extends StatelessWidget {
  const ChooseBarberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageStaffBloc(Get.arguments[ConstRes.salonData]),
      child: Scaffold(
        body: BlocBuilder<ManageStaffBloc, ManageStaffState>(
          builder: (context, state) {
            ManageStaffBloc manageStaffBloc = context.read<ManageStaffBloc>();
            return Column(
              children: [
                ToolBarWidget(
                  title: AppLocalizations.of(context)!.chooseYourExpert,
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: ColorRes.smokeWhite,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: manageStaffBloc.searchController,
                    style: kRegularEmpressTextStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.search,
                      hintStyle: kRegularEmpressTextStyle.copyWith(
                        color: ColorRes.darkGray,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (context, index) {
                      StaffData? staffData = manageStaffBloc.staffs?[index];
                      return CustomCircularInkWell(
                        onTap: () {
                          manageStaffBloc.onClickBarber(index);
                        },
                        child: ItemStaff(
                          staffData: staffData,
                          isSelected:
                              manageStaffBloc.selectedStaff?.id?.toInt() ==
                                  staffData?.id?.toInt(),
                        ),
                      );
                    },
                    itemCount: manageStaffBloc.staffs?.length ?? 0,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: SafeArea(
                    top: false,
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: TextButton(
                        style: kButtonThemeStyle,
                        onPressed: () {
                          manageStaffBloc.confirmBarber();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.confirmBarber,
                          style: kRegularWhiteTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ItemStaff extends StatelessWidget {
  const ItemStaff({
    super.key,
    required this.staffData,
    required this.isSelected,
  });

  final StaffData? staffData;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 10,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: ColorRes.smokeWhite2,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? ColorRes.themeColor : ColorRes.transparent,
          width: 2,
        ),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              color: ColorRes.smokeWhite,
              height: 70,
              width: 70,
              child: FadeInImage.assetNetwork(
                image: '${ConstRes.itemBaseUrl}${staffData?.photo}',
                fit: BoxFit.cover,
                placeholder: '1',
                placeholderErrorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Image(
                      image: AssetImage(AssetRes.icUser),
                    ),
                  );
                },
                imageErrorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Image(
                      image: AssetImage(AssetRes.icUser),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${staffData?.name}',
                style: kMediumTextStyle.copyWith(
                  fontSize: 17,
                  color: ColorRes.nero,
                ),
              ),
              Text(
                AppRes.getGenderTypeInStringFromNumber(
                    context, staffData?.gender?.toInt() ?? 0),
                style: kThinWhiteTextStyle.copyWith(
                  color: ColorRes.subTitleText,
                  letterSpacing: 1,
                  fontSize: 13,
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: ColorRes.pumpkin15,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    margin: const EdgeInsets.only(top: 3, right: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${staffData?.rating != 0 ? staffData?.rating?.toStringAsFixed(1) : staffData?.rating}',
                          style: kSemiBoldTextStyle.copyWith(
                            color: ColorRes.pumpkin,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.star_rounded,
                          color: ColorRes.pumpkin,
                          size: 16,
                        )
                      ],
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.totalOrders,
                    style: kLightWhiteTextStyle.copyWith(
                      color: ColorRes.subTitleText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '${staffData?.bookingsCount ?? 0}',
                    style: kBoldThemeTextStyle.copyWith(
                      fontSize: 16,
                      color: ColorRes.nero,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}