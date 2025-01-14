import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rrbikerental/views/home_page/home_page.dart';
import 'package:rrbikerental/views/phone_auth_web_screen.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.size,
    required this.width,
  });

  final Size size;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width > 1400 ? (width * .08) : 8,
        vertical: 8,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MouseRegion(
                cursor: SystemMouseCursors.click,
                // onHover: (event) {},
                child: GestureDetector(
                  onTap: () {
                    context.go('/');
                  },
                  child: Row(
                    children: [
                      Container(
                        // color: Colors.red,
                        height: 100,
                        width: 100,
                        child: Image.asset('assets/images/logo.png',
                            fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'RR BIKE RENTALS',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              width > 1400
                  ? MenuBar()
                  : IconButton(
                      icon: const Icon(Icons.menu, size: 30),
                      onPressed: () => _showMenuPopup(context),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMenuPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MenuButton(
                  text: 'Home',
                  onTap: () {
                    context.go('/');
                    Navigator.pop(context); // Close the dialog
                  },
                ),
                const Divider(),
                MenuButton(
                  text: 'About Us',
                  onTap: () {
                    context.go('/');
                    Navigator.pop(context); // Close the dialog
                  },
                ),
                const Divider(),
                MenuButton(
                  text: 'Book Your Bike',
                  onTap: () {
                    context.go('/bookyourbike');
                    Navigator.pop(context); // Close the dialog
                  },
                ),
                const Divider(),
                AuthStateHandler(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData) {
          // User is logged in
          return Row(
            children: [
              UserInfoIcon(),
              SizedBox(width: 30),
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Logout',
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ); // Your app's home screen
        }
        // User is not logged in
        return SignInButton(
          onTap: () {
            showDialog(
                context: context, builder: (ctx) => const PhoneAuthPopup());
          },
        ); // Your login or welcome screen
      },
    );
  }
}

class UserInfoIcon extends StatefulWidget {
  const UserInfoIcon({Key? key}) : super(key: key);

  @override
  _UserInfoIconState createState() => _UserInfoIconState();
}

class _UserInfoIconState extends State<UserInfoIcon> {
  double _scale = 1.0;

  void _fetchAndShowUserInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No user is logged in.")),
      );
      return;
    }

    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        if (userData != null) {
          _showUserInfoPopup(userData);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User data not found.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching user info: $e")),
      );
    }
  }

  void _showUserInfoPopup(Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("User Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Name: ${userData['name'] ?? 'N/A'}"),
              Text("Email: ${userData['email'] ?? 'N/A'}"),
              Text("Phone: ${userData['phone'] ?? 'N/A'}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _scale = 1.2),
      onExit: (_) => setState(() => _scale = 1.0),
      child: GestureDetector(
        onTap: _fetchAndShowUserInfo,
        child: AnimatedScale(
          scale: _scale,
          duration: Duration(milliseconds: 200),
          child: Icon(
            Icons.person,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}

class SignInButton extends StatefulWidget {
  final VoidCallback onTap;

  const SignInButton({Key? key, required this.onTap}) : super(key: key);

  @override
  _SignInButtonState createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _scale = 1.1), // Grow on hover
      onExit: (_) => setState(() => _scale = 1.0), // Reset on hover exit
      child: GestureDetector(
        onTap: widget.onTap, // Trigger the provided onTap action
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200), // Smooth transition
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(_scale), // Scale transformation
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Sign In',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class MenuBar extends StatelessWidget {
  const MenuBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    return SizedBox(
      width: width * .3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MenuButton(
            text: 'Home',
            onTap: () {
              context.go('/');
            },
          ),
          MenuButton(
            text: 'About Us',
            onTap: () {
              context.go('/aboutus');
            },
          ),
          MenuButton(
            text: 'Book Your Bike',
            onTap: () {
              context.go('/bookyourbike');
            },
          ),
          // Icon(
          //   Icons.account_circle,
          //   size: 36,
          // ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8),
          //     color: Theme.of(context).primaryColor,
          //   ),
          //   child: Text(
          //     'Sign In',
          //     style: Theme.of(context)
          //         .textTheme
          //         .titleSmall!
          //         .copyWith(fontWeight: FontWeight.bold),
          //   ),
          // ),

          AuthStateHandler(),
        ],
      ),
    );
  }
}

class MenuButton extends StatefulWidget {
  const MenuButton({
    required this.text,
    required this.onTap,
    super.key,
  });

  final String text;
  final VoidCallback onTap;

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _scale = 1.1; // Increase size on hover
        });
      },
      onExit: (_) {
        setState(() {
          _scale = 1.0; // Reset size when hover ends
        });
      },
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Transform.scale(
          scale: _scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              widget.text,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
