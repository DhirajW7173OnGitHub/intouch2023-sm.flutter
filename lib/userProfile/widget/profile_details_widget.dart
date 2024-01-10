import 'package:flutter/material.dart';

class UserProfileDetailsWidget extends StatelessWidget {
  const UserProfileDetailsWidget({
    super.key,
    this.email,
    this.name,
    this.phone,
    this.id,
    this.rollName,
    this.onTap,
  });

  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  // final String? address;
  final String? rollName;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFAF3F3), //CommonColor.CONTAINER_COLOR,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    buildUserProfileField(
                      context,
                      icon: const Icon(Icons.person),
                      label: 'Name',
                      value: '$name',
                    ),
                    buildUserProfileField(
                      context,
                      icon: const Icon(Icons.email),
                      label: 'Email',
                      value: '$email',
                    ),
                    buildUserProfileField(
                      context,
                      icon: const Icon(Icons.mobile_friendly_outlined),
                      label: 'Mobile Number',
                      value: '$phone',
                    ),
                    buildUserProfileField(
                      context,
                      icon: const Icon(Icons.location_city),
                      label: 'Roll Name',
                      value: '$rollName',
                    ),
                    buildUserProfileField(
                      context,
                      icon: const Icon(Icons.shop_2_outlined),
                      label: 'User Id',
                      value: '$id',
                    ),
                    buildUserProfileField(
                      context,
                      icon: const Icon(Icons.shop),
                      label: 'Shop code',
                      value: '12345',
                    ),
                    buildUserProfileField(
                      context,
                      onTap: onTap,
                      icon: const Icon(Icons.password),
                      label: 'Password',
                      isEditable: true,
                      value: '****',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUserProfileField(
    BuildContext context, {
    required String label,
    required String value,
    Widget? icon,
    bool isEditable = false,
    Function()? onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(seconds: 1),
          builder: (context, value, Widget? child) {
            return Opacity(
              opacity: value,
              child: Padding(
                padding: EdgeInsets.only(left: value * 10),
                child: child,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: icon,
                    ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Text(
                              value,
                              maxLines: 2,
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.visible,
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isEditable == true)
                              InkWell(
                                onTap: onTap,
                                child: Wrap(
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.60,
                                    ),
                                    isEditable
                                        ? const Icon(Icons.edit)
                                        : Container(),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
