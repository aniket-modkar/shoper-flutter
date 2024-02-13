import 'package:flutter/material.dart';
import 'package:shoper_flutter/core/app_export.dart';
import 'package:shoper_flutter/presentation/profile_screen/widgets%20/circle.dart';
import 'package:shoper_flutter/widgets/custom_image_view.dart';

class ProfileImage extends StatelessWidget {
  final String imagePath;
  final BorderRadius radius;
  final AnimationController? animationController;

  const ProfileImage({
    required this.imagePath,
    required this.radius,
    this.animationController,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomImageView(
          height: 72.adaptSize,
          width: 72.adaptSize,
          imagePath: imagePath,
          radius: radius,
        ),
        Positioned.fill(
          child: Circle(animationController: animationController),
        ),
      ],
    );
  }
}
