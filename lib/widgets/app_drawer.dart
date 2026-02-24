import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/theme_provider.dart';
import '../providers/user_profile_provider.dart';
import '../providers/favorites_provider.dart';
import '../screens/profile_management_screen.dart';
import '../theme/app_theme.dart';
import 'package:intl/intl.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<UserProfileProvider>(context);
    final currentProfile = profileProvider.currentProfile;

    return Drawer(
      backgroundColor: AppTheme.getCardColor(context),
      child: SafeArea(
        child: Column(
          children: [
            // Profile Header
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                if (currentProfile != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileManagementScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileManagementScreen(),
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.getBorderColor(context),
                      width: 1,
                    ),
                  ),
                ),
                child: currentProfile != null
                    ? Row(
                        children: [
                          // Profile photo placeholder
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppTheme.getPrimaryColor(context),
                              border: Border.all(
                                color: AppTheme.getPrimaryColor(context),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.person,
                              color: AppTheme.getBackgroundColor(context),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentProfile.username.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                    color: AppTheme.getTextColor(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap to manage',
                                  style: TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1,
                                    color: AppTheme.getSecondaryTextColor(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            'NO PROFILE',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: AppTheme.getSecondaryTextColor(context),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to create',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1,
                              color: AppTheme.getSecondaryTextColor(context),
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Menu items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  // Account Management Section
                  _buildSectionHeader(context, 'ACCOUNTS'),
                  
                  if (currentProfile != null) ...[
                    _buildMenuItem(
                      context,
                      icon: Icons.switch_account,
                      title: 'Switch Account',
                      onTap: () => _showAccountSwitcher(context, profileProvider),
                    ),
                    _buildMenuItem(
                      context,
                      icon: Icons.person_add,
                      title: 'Create New Account',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileManagementScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                  
                  const SizedBox(height: 24),
                  
                  // Theme toggle
                  _buildSectionHeader(context, 'APPEARANCE'),
                  _buildThemeToggle(context, themeProvider),
                  
                  const SizedBox(height: 24),
                  
                  // Data management
                  _buildSectionHeader(context, 'DATA'),
                  _buildMenuItem(
                    context,
                    icon: Icons.download_outlined,
                    title: 'Export Favorites',
                    onTap: () => _exportFavorites(context),
                  ),
                  if (currentProfile != null)
                    _buildMenuItem(
                      context,
                      icon: Icons.delete_outline,
                      title: 'Delete Profile',
                      onTap: () => _confirmDeleteProfile(context, profileProvider),
                      isDestructive: true,
                    ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppTheme.getBorderColor(context),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                'Version 4.1.0',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: AppTheme.getSecondaryTextColor(context),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 2,
          color: AppTheme.getSecondaryTextColor(context),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 20,
        color: isDestructive 
            ? Colors.red 
            : AppTheme.getTextColor(context),
      ),
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
          color: isDestructive 
              ? Colors.red 
              : AppTheme.getTextColor(context),
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }

  Widget _buildThemeToggle(BuildContext context, ThemeProvider themeProvider) {
    final isDark = themeProvider.isDarkMode;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.getBackgroundColor(context),
        border: Border.all(
          color: AppTheme.getBorderColor(context),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildThemeOption(
              context,
              label: 'LIGHT',
              icon: Icons.light_mode_outlined,
              isSelected: !isDark,
              onTap: () {
                if (isDark) themeProvider.toggleTheme();
              },
            ),
          ),
          Expanded(
            child: _buildThemeOption(
              context,
              label: 'DARK',
              icon: Icons.dark_mode_outlined,
              isSelected: isDark,
              onTap: () {
                if (!isDark) themeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.getPrimaryColor(context) : Colors.transparent,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected 
                  ? AppTheme.getBackgroundColor(context)
                  : AppTheme.getSecondaryTextColor(context),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
                color: isSelected 
                    ? AppTheme.getBackgroundColor(context)
                    : AppTheme.getSecondaryTextColor(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountSwitcher(BuildContext context, UserProfileProvider profileProvider) {
    final allProfiles = profileProvider.getAllProfiles();
    final currentId = profileProvider.currentUserId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.getCardColor(context),
        shape: const RoundedRectangleBorder(),
        title: Text(
          'SWITCH ACCOUNT',
          style: TextStyle(
            color: AppTheme.getTextColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allProfiles.length,
            itemBuilder: (context, index) {
              final profile = allProfiles[index];
              final isActive = profile.id == currentId;
              
              return ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive 
                        ? AppTheme.getPrimaryColor(context)
                        : AppTheme.getBackgroundColor(context),
                    border: Border.all(
                      color: AppTheme.getBorderColor(context),
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: isActive
                        ? AppTheme.getBackgroundColor(context)
                        : AppTheme.getTextColor(context),
                    size: 20,
                  ),
                ),
                title: Text(
                  profile.username,
                  style: TextStyle(
                    color: AppTheme.getTextColor(context),
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                trailing: isActive
                    ? Icon(
                        Icons.check,
                        color: AppTheme.getPrimaryColor(context),
                        size: 20,
                      )
                    : null,
                onTap: isActive
                    ? null
                    : () async {
                        await profileProvider.switchProfile(profile.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        }
                      },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: AppTheme.getTextColor(context),
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportFavorites(BuildContext context) async {
    final favoritesProvider = Provider.of<FavoritesProvider>(context, listen: false);
    final favorites = favoritesProvider.favorites;

    if (favorites.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No favorites to export',
            style: TextStyle(color: AppTheme.getBackgroundColor(context)),
          ),
          backgroundColor: AppTheme.getPrimaryColor(context),
        ),
      );
      return;
    }

    final buffer = StringBuffer();
    buffer.writeln('NEXTUP - My Favorites');
    buffer.writeln('Exported: ${DateFormat('MMM d, y').format(DateTime.now())}');
    buffer.writeln('${'=' * 50}\n');

    for (final fav in favorites) {
      buffer.writeln('Title: ${fav.title}');
      buffer.writeln('Type: ${fav.contentType.toUpperCase()}');
      buffer.writeln('Release: ${DateFormat('MMM d, y').format(fav.releaseDate)}');
      if (fav.genres != null && fav.genres!.isNotEmpty) {
        buffer.writeln('Genres: ${fav.genres!.join(', ')}');
      }
      if (fav.overview != null) {
        buffer.writeln('Overview: ${fav.overview}');
      }
      buffer.writeln('-' * 50);
    }

    final exportText = buffer.toString();

    try {
      await Share.share(
        exportText,
        subject: 'NextUp Favorites Export',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Favorites shared successfully',
              style: TextStyle(color: AppTheme.getBackgroundColor(context)),
            ),
            backgroundColor: AppTheme.getPrimaryColor(context),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        await Clipboard.setData(ClipboardData(text: exportText));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Copied to clipboard!',
              style: TextStyle(color: AppTheme.getBackgroundColor(context)),
            ),
            backgroundColor: AppTheme.getPrimaryColor(context),
          ),
        );
      }
    }
  }

  Future<void> _confirmDeleteProfile(
    BuildContext context,
    UserProfileProvider profileProvider,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.getCardColor(context),
        shape: const RoundedRectangleBorder(),
        title: Text(
          'DELETE PROFILE',
          style: TextStyle(
            color: AppTheme.getTextColor(context),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
        content: Text(
          'This will permanently delete this profile. Your favorites and watched items will be kept for other profiles. This action cannot be undone.',
          style: TextStyle(
            color: AppTheme.getSecondaryTextColor(context),
            fontSize: 12,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'CANCEL',
              style: TextStyle(
                color: AppTheme.getTextColor(context),
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'DELETE PROFILE',
              style: TextStyle(
                color: Colors.red,
                fontSize: 11,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await profileProvider.deleteCurrentProfile();
      
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Profile deleted',
              style: TextStyle(color: AppTheme.getBackgroundColor(context)),
            ),
            backgroundColor: AppTheme.getPrimaryColor(context),
          ),
        );
      }
    }
  }
}
