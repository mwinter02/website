import 'package:flutter/material.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  @override
  Widget build(BuildContext context) {
    // Example data
    final name = 'Max Winter';
    final education = 'BSc Computer Science, University of Example';
    final interests = 'Game Dev, AI, Robotics';
    final profilePic = const AssetImage('assets/images/profile_picture.png');
    final badges = [
      const Badge(icon: Icons.code, displayName: 'C++'),
      const Badge(icon: Icons.bug_report, displayName: 'Python'),
      const Badge(icon: Icons.android, displayName: 'Java'),
      const Badge(icon: Icons.web, displayName: 'HTML'),
      const Badge(icon: Icons.storage, displayName: 'SQL'),
      // Add more badges as needed
    ];

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        education,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Text('Interests:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      Text(interests, style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                CircleAvatar(
                  radius: 48,
                  backgroundImage: profilePic,
                  backgroundColor: Colors.green.shade100,
                ),
              ],
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: badges
                    .map((b) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: b,
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final IconData icon;
  final String displayName;

  const Badge({required this.icon, required this.displayName, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
            border: Border.all(color: Colors.grey.shade400, width: 1.5),
          ),
          child: Icon(icon, size: 28, color: Colors.blueGrey),
        ),
        const SizedBox(height: 4),
        Text(
          displayName,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}