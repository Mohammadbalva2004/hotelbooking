import 'package:flutter/material.dart';
import 'package:hotelbooking/features/screen/auth/signin/signin_screen.dart';
import 'package:hotelbooking/features/screen/booking/booking_screen.dart';
import 'package:hotelbooking/features/screen/home/home_screen.dart';
import 'package:hotelbooking/features/screen/policy/policy_screen.dart';
import 'package:hotelbooking/features/screen/profileedit/profile_edit_screen.dart';
import 'package:hotelbooking/features/screen/splash/splash_screen.dart';
import 'package:hotelbooking/features/screen/termcondition/term_condition_screen.dart';
import 'package:hotelbooking/features/widgets/commonbottomnavbar/common_bottom_nav_bar.dart';
import 'package:hotelbooking/features/widgets/commonbutton/common_buttom.dart';
import 'package:hotelbooking/features/widgets/commonprofilebutton/comman_profile_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _navigateToTab(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BookingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(160),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "My Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/images/profile.jpg",
                            fit: BoxFit.cover,
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Curtis Weaver",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          Text(
                            "CurtisWeaver@example.com",
                            style: TextStyle(color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(width: 2, color: Colors.white),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          size: 30,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileOptionTile(
              icon: Icons.edit,
              title: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileEditScreen(),
                  ),
                );
              },
            ),
            ProfileOptionTile(icon: Icons.lock, title: 'Change Password'),
            ProfileOptionTile(icon: Icons.payment, title: 'Payment Method'),
            ProfileOptionTile(icon: Icons.calendar_today, title: 'My Bookings'),
            ProfileOptionTile(
              icon: Icons.edit,
              title: 'Dark Mode',
              trailing: Switch(value: false, onChanged: (bool value) {}),
            ),
            ProfileOptionTile(
              icon: Icons.security,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PolicyScreen()),
                );
              },
            ),
            ProfileOptionTile(
              icon: Icons.description,
              title: 'Terms & Conditions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TermConditionScreen(),
                  ),
                );
              },
              showDivider: false,
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 20.0,
            //     vertical: 30,
            //   ),
            //   child: SizedBox(
            //     height: 50,
            //     width: double.infinity,
            //     child: ElevatedButton.icon(
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color(0xFF1190F8),
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(10),
            //         ),
            //       ),
            //       onPressed: () {},
            //       icon: const Icon(Icons.logout, color: Colors.white),
            //       label: const Text(
            //         'Logout',
            //         style: TextStyle(color: Colors.white, fontSize: 19),
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30,
              ),
              child: CustomButton(
                text: "Logout",
                width: double.infinity,
                prefixIcon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                  size: 24,
                ),
                onPressed: () async {
                  var sharedPref = await SharedPreferences.getInstance();

                  sharedPref.remove(SplashScreenState.KEYLOGIN);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SigninScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNavBar(
        currentIndex: 4,
        onTap: (index) => _navigateToTab(context, index),
      ),
    );
  }
}
