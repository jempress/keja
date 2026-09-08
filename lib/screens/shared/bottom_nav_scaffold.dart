import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../agent/agent_dashboard_screen.dart';
import '../agent/post_listing_screen.dart';
import '../browse/browse_screen.dart';
import '../chat/conversation_list_screen.dart';
import '../saved/saved_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final isAgent = context.watch<AuthProvider>().isAgent;

    final screens = [
      const BrowseScreen(),
      const SavedScreen(),
      const ConversationListScreen(),
      if (isAgent) const AgentDashboardScreen(),
    ];

    final destinations = [
      const NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Browse'),
      const NavigationDestination(icon: Icon(Icons.favorite_border), selectedIcon: Icon(Icons.favorite), label: 'Saved'),
      const NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Messages'),
      if (isAgent) const NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Agent'),
    ];

    final safeIndex = _index.clamp(0, screens.length - 1);

    return Scaffold(
      body: screens[safeIndex],
      floatingActionButton: isAgent && safeIndex == screens.length - 1
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PostListingScreen())),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: destinations,
      ),
    );
  }
}
