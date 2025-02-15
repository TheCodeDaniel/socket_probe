import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: size.width * 0.4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 20,
          children: [
            Text("Settings", style: TextStyle(fontSize: 30)),
            ListTile(
              leading: Icon(Iconsax.moon),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              tileColor: Colors.indigo.withValues(alpha: 0.2),
              title: Text("Dark Mode"),
              subtitle: Text("Coming soon .."),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
