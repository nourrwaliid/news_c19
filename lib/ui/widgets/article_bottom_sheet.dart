import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/screens/article/article_full_screen.dart';
import 'package:news_c19/ui/utils/build_context_extensions.dart';

void showArticleBottomSheet(BuildContext context, ArticleDM article) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => ArticleBottomSheet(articleDM: article),
  );
}

class ArticleBottomSheet extends StatelessWidget {
  final ArticleDM articleDM;

  const ArticleBottomSheet({super.key, required this.articleDM});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: articleDM.urlToImage ?? "",
              height: context.height * .25,
              width: double.infinity,
              fit: BoxFit.cover,
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          SizedBox(height: 12),
          Text(articleDM.title ?? "",
              style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text(articleDM.description ?? "", style: TextStyle(color: Colors.black87)),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, padding: EdgeInsets.all(16)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ArticleFullScreen(url: articleDM.url ?? "")),
                );
              },
              child: Text("View Full Articel", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }
}