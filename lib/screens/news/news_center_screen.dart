import 'package:flutter/material.dart';

import '../../controllers/news_controller.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/providers/notifier_provider.dart';
import '../../widgets/components/news_card.dart';
import '../shared/tradex_bottom_nav.dart';

class NewsCenterScreen extends StatelessWidget {
  const NewsCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final news = NotifierProvider.of<NewsController>(context);
    final strings = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(strings.t('news'))),
      bottomNavigationBar: const TradeXBottomNav(currentIndex: 3),
      body: RefreshIndicator(
        onRefresh: () => news.refresh(),
        child: ListView.separated(
          padding: const EdgeInsets.all(24),
          itemCount: news.items.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            if (index >= news.items.length) {
              if (news.hasMore) {
                news.loadMore();
                return const Center(child: CircularProgressIndicator());
              }
              return const SizedBox.shrink();
            }
            final item = news.items[index];
            return NewsCard(
              item: item,
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Open ${item.url}')));
              },
            );
          },
        ),
      ),
    );
  }
}
