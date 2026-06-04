// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter2/core/theme/theme_cubit.dart';
import 'package:flutter2/core/widgets/app_drawer.dart';
import 'package:flutter2/posts/bloc/post_bloc.dart';
import 'package:flutter2/posts/bloc/post_event.dart';
import 'package:flutter2/posts/bloc/post_state.dart';
import 'package:flutter2/posts/widgest/bottom_loader.dart';
import 'package:flutter2/posts/widgest/post_list_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        switch (state.status) {
          case PostStatus.failure:
            print('failed to fetch data posts');
            return Scaffold(
              appBar: AppBar(
                title: Text("Post List"),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                ),
              
              drawer: AppDrawer(),
              body: Center(child: Text('Failed to fetch data posts')),
            );
          case PostStatus.success:
            if (state.posts.isEmpty) {
              print('no posts');
              return Scaffold(
                appBar: AppBar(
                  title: Text("Post List"),
                    actions: [
                      IconButton(
                        onPressed: () {
                          context.read<ThemeCubit>().toggleTheme();
                        },
                        icon: Icon(Icons.dark_mode),
                      ),
                    ],
                  ),

                drawer: AppDrawer(),
                body: Center(child: Text('no posts')),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: Text("Post List"),
                  actions: [
                    IconButton(
                      onPressed: () {
                        context.read<ThemeCubit>().toggleTheme();
                      },
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                ),
              drawer: AppDrawer(),
              body: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.posts.length
                      ? const BottomLoader()
                      : PostListItem(post: state.posts[index]);
                },
                itemCount: state.hasReachedMax
                    ? state.posts.length
                    : state.posts.length + 1,
                controller: _scrollController,
              ),
            );

          case PostStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PostBloc>().add(PostFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
