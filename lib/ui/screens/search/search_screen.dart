import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news_c19/api/api_manager.dart';
import 'package:news_c19/model/articles_response.dart';
import 'package:news_c19/ui/widgets/article_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  List<ArticleDM> _results = [];
  bool _isLoading = false;
  String _errorMessage = '';
  Timer? _debounce;

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: 500), () {
      if (query.trim().isEmpty) {
        setState(() => _results = []);
        return;
      }
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      var articles = await ApiManager.searchArticles(query);
      setState(() {
        _results = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                autofocus: true,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                ),
              ),
              Expanded(child: _buildBody()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return Center(child: CircularProgressIndicator());
    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: TextStyle(color: Colors.white)));
    }
    if (_results.isEmpty) {
      return Center(child: Text("Search for articles", style: TextStyle(color: Colors.white)));
    }
    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) => ArticleWidget(articleDM: _results[index]),
    );
  }
}