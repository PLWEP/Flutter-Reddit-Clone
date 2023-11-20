import 'package:flutter/material.dart';
import 'package:flutter_reddit_clone/common/error_text.dart';
import 'package:flutter_reddit_clone/common/loader.dart';
import 'package:flutter_reddit_clone/common/post_card.dart';
import 'package:flutter_reddit_clone/features/post/provider/post_provider.dart';
import 'package:flutter_reddit_clone/features/post/widget/comment_card.dart';
import 'package:flutter_reddit_clone/models/post_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: ref.watch(getPostByIdProvider(widget.postId)).when(
              data: (data) {
                return Column(
                  children: [
                    PostCard(post: data),
                    TextField(
                      onSubmitted: (val) => addComment(data),
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'What are your thoughts?',
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                    ref.watch(getPostCommentsProvider(widget.postId)).when(
                          data: (comments) => Expanded(
                            child: ListView.builder(
                              itemCount: comments.length,
                              itemBuilder: (context, index) {
                                final comment = comments[index];
                                return CommentCard(comment: comment);
                              },
                            ),
                          ),
                          error: (error, stackTrace) =>
                              ErrorText(error: error.toString()),
                          loading: () => const Loader(),
                        ),
                  ],
                );
              },
              error: (error, stackTrace) => ErrorText(error: error.toString()),
              loading: () => const Loader(),
            ),
      );
}
