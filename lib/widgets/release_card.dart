import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../models/release_item.dart';
import '../providers/favorites_provider.dart';
import '../providers/watched_provider.dart';
import '../services/tmdb_service.dart';
import '../theme/app_theme.dart';

class ReleaseCard extends StatelessWidget {
  final ReleaseItem item;
  final bool blindMode;

  const ReleaseCard({
    super.key,
    required this.item,
    this.blindMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final watchedProvider = Provider.of<WatchedProvider>(context);
    final isFavorite = favoritesProvider.isFavorite(item.id);
    final isWatched = watchedProvider.isWatched(item.id);

    final textPrimary = AppTheme.getTextColor(context);
    final textSecondary = AppTheme.getSecondaryTextColor(context);
    final borderColor = AppTheme.getBorderColor(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: AppTheme.cardDecoration(context),
      child: InkWell(
        onTap: blindMode ? null : () => _showDetails(context),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPoster(context),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title — was hardcoded textWhite, now theme-aware
                    Text(
                      blindMode ? '█████████████' : item.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isWatched ? textSecondary : textPrimary,
                        letterSpacing: 0.5,
                        decoration: isWatched ? TextDecoration.lineThrough : null,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildTypeBadge(context),
                        if (!blindMode && item.platforms.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          _buildPlatformBadge(),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Release date — was hardcoded textGray
                    Text(
                      DateFormat('MMM d, y').format(item.releaseDate).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: textSecondary,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _buildCountdownChip(context),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Action buttons
              Column(
                children: [
                  // Favorite
                  GestureDetector(
                    onTap: () {
                      if (isFavorite) {
                        favoritesProvider.removeFavorite(item.id);
                      } else {
                        favoritesProvider.addFavorite(item);
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isFavorite ? AppTheme.accentGold : Colors.transparent,
                        border: Border.all(
                          color: isFavorite ? AppTheme.accentGold : borderColor,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? AppTheme.primaryBlack : textSecondary,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Watched
                  GestureDetector(
                    onTap: () {
                      if (isWatched) {
                        watchedProvider.unmarkWatched(item.id);
                      } else {
                        _showWatchedDialog(context);
                      }
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isWatched
                            ? Colors.green.withOpacity(0.1)
                            : Colors.transparent,
                        border: Border.all(
                          color: isWatched ? Colors.green : borderColor,
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        isWatched ? Icons.check : Icons.check_box_outline_blank,
                        color: isWatched ? Colors.green : textSecondary,
                        size: 16,
                      ),
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

  // ── Poster ───────────────────────────────────────────────────

  Widget _buildPoster(BuildContext context) {
    final cardColor = AppTheme.getCardColor(context);
    final borderColor = AppTheme.getBorderColor(context);
    final textSecondary = AppTheme.getSecondaryTextColor(context);

    if (blindMode) {
      return Container(
        width: 50,
        height: 75,
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor),
        ),
        child: Icon(Icons.question_mark, color: textSecondary, size: 20),
      );
    }

    final posterUrl = item.contentType == 'anime'
        ? item.posterPath ?? ''
        : TMDBService.getPosterUrl(item.posterPath);

    if (posterUrl.isEmpty) {
      return Container(
        width: 50,
        height: 75,
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor),
        ),
        child: Icon(
          item.contentType == 'movie'
              ? Icons.movie
              : item.contentType == 'tv'
                  ? Icons.tv
                  : Icons.animation,
          color: textSecondary,
          size: 20,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: posterUrl,
      width: 50,
      height: 75,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          Container(width: 50, height: 75, color: cardColor),
      errorWidget: (context, url, error) => Container(
        width: 50,
        height: 75,
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor),
        ),
        child: Icon(Icons.error, color: textSecondary, size: 20),
      ),
    );
  }

  // ── Type badge ───────────────────────────────────────────────

  Widget _buildTypeBadge(BuildContext context) {
    final label = item.contentType == 'movie'
        ? 'MOVIE'
        : item.contentType == 'tv'
            ? 'TV SHOW'
            : 'ANIME';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w600,
          color: AppTheme.getSecondaryTextColor(context),
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ── Platform badge (accent gold — same in both themes) ───────

  Widget _buildPlatformBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.1),
        border: Border.all(color: AppTheme.accentGold, width: 1),
      ),
      child: Text(
        item.platforms.first.toUpperCase(),
        style: const TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.w600,
          color: AppTheme.accentGold,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  // ── Countdown chip ───────────────────────────────────────────

  Widget _buildCountdownChip(BuildContext context) {
    if (item.isReleased) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.getBorderColor(context), width: 1),
        ),
        child: Text(
          'RELEASED',
          style: TextStyle(
            fontSize: 9,
            color: AppTheme.getSecondaryTextColor(context),
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppTheme.accentGold.withOpacity(0.1),
        border: Border.all(color: AppTheme.accentGold, width: 1),
      ),
      child: Text(
        item.countdownText.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          color: AppTheme.accentGold,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  // ── Detail bottom sheet ──────────────────────────────────────

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.getScaffoldColor(context),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      builder: (ctx) {
        final textPrimary = AppTheme.getTextColor(ctx);
        final textSecondary = AppTheme.getSecondaryTextColor(ctx);
        final borderColor = AppTheme.getBorderColor(ctx);

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  color: borderColor,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.backdropPath != null)
                        Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: TMDBService.getPosterUrl(item.backdropPath!),
                            fit: BoxFit.cover,
                          ),
                        ),

                      const SizedBox(height: 16),

                      // Title — was hardcoded textWhite
                      Text(
                        item.title.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildTypeBadge(ctx),
                          const SizedBox(width: 8),
                          _buildCountdownChip(ctx),
                          if (item.platforms.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            _buildPlatformBadge(),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),
                      _buildInfoRow(
                        ctx,
                        'RELEASE DATE',
                        DateFormat('MMMM d, y').format(item.releaseDate),
                      ),

                      if (item.overview != null &&
                          item.overview!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        // "OVERVIEW" label — was hardcoded textWhite
                        Text(
                          'OVERVIEW',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textPrimary,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Body — was hardcoded textGray
                        Text(
                          item.overview!,
                          style: TextStyle(
                            fontSize: 13,
                            color: textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Info row ─────────────────────────────────────────────────

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: AppTheme.getSecondaryTextColor(context),
                letterSpacing: 1,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                // Was hardcoded textWhite
                color: AppTheme.getTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Watched dialog ───────────────────────────────────────────

  void _showWatchedDialog(BuildContext context) {
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        final textPrimary = AppTheme.getTextColor(ctx);
        final textSecondary = AppTheme.getSecondaryTextColor(ctx);
        final borderColor = AppTheme.getBorderColor(ctx);
        final cardColor = AppTheme.getCardColor(ctx);
        final scaffoldColor = AppTheme.getScaffoldColor(ctx);

        return AlertDialog(
          // Was hardcoded cardBlack
          backgroundColor: cardColor,
          shape: const RoundedRectangleBorder(),
          title: Text(
            'MARK AS WATCHED',
            style: TextStyle(
              // Was hardcoded textWhite
              color: textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add a private note (optional):',
                // Was hardcoded textGray
                style: TextStyle(color: textSecondary, fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: noteController,
                maxLength: 100,
                // Was hardcoded textWhite
                style: TextStyle(color: textPrimary, fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'One line note...',
                  hintStyle: TextStyle(color: textSecondary, fontSize: 11),
                  filled: true,
                  // Was hardcoded primaryBlack
                  fillColor: scaffoldColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: borderColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppTheme.accentGold),
                  ),
                  counterStyle: TextStyle(color: textSecondary, fontSize: 10),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'CANCEL',
                // Was hardcoded textWhite — now readable on light dialogs too
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Provider.of<WatchedProvider>(ctx, listen: false).markAsWatched(
                  item.id,
                  item.title,
                  item.contentType,
                  note: noteController.text.isEmpty
                      ? null
                      : noteController.text,
                );
                Navigator.pop(ctx);
              },
              child: const Text(
                'MARK WATCHED',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}