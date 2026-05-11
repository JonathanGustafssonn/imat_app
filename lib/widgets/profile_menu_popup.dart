import 'package:flutter/material.dart';
import 'package:imat_app/widgets/profile_button.dart';

class ProfileMenuPopup extends StatefulWidget {
  const ProfileMenuPopup({super.key});

  @override
  State<ProfileMenuPopup> createState() => _ProfileMenuPopupState();
}

class _ProfileMenuPopupState extends State<ProfileMenuPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  String? selectedMenu;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildProfileMenuButton(String label, IconData icon) {
    return ProfileButton(label: label, icon: icon, onTap: () => setState(() => selectedMenu = label),);}

  Widget _buildSelectedMenu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titel
        Text(
          selectedMenu!,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
        ),

        const SizedBox(height: 20),

        // Dummy text — byt ut mot riktig funktionalitet senare
        Text(
          "Här visas innehållet för \"$selectedMenu\".",
          style: const TextStyle(
            fontSize: 18,
            decoration: TextDecoration.none,
            color: Colors.black,
          ),
        ),

        const Spacer(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Mörk overlay
        GestureDetector(
          onTap: () {if (selectedMenu != null) {setState(() => selectedMenu = null);} else {Navigator.pop(context);}},
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),

        // Slide-in panel
        Align(
          alignment: Alignment.centerRight,
          child: SlideTransition(
            position: _slideAnimation,
            child: Container(
              width: 350,
              height: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
                border: Border.all(color: Colors.black, width: 5),
              ),
              padding: const EdgeInsets.all(25),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titel + kryss
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, size: 32, color: Colors.black),
                        onPressed: () {if (selectedMenu != null) {setState(() => selectedMenu = null);} else {Navigator.pop(context);}},
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),

                      Text(
                        selectedMenu == null ? "Profil" : selectedMenu!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Huvudmeny eller vald meny
                  Expanded(
                    child: selectedMenu == null
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                _buildProfileMenuButton("Inställningar", Icons.settings),
                                const SizedBox(height: 10),
                                _buildProfileMenuButton("Gillade varor", Icons.favorite),
                                SizedBox(height: 10),
                                _buildProfileMenuButton("Inköpslistor", Icons.list_alt),
                                const SizedBox(height: 10),
                                _buildProfileMenuButton("Kvitton", Icons.receipt_long),
                              ],
                            ),
                          )
                        : _buildSelectedMenu(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
