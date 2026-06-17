import 'package:flutter/material.dart';
import 'package:my_bookkeeping/service/api_service.dart';
import 'package:provider/provider.dart';
import 'package:my_bookkeeping/utils/app_state.dart';
import 'package:my_bookkeeping/enum/enum.dart';
import 'package:my_bookkeeping/widgets/animated_dots.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _ShowBottom();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      appState.addMessage(ChatMessage(
        content: text,
        isUser: true,
      ));
      appState.setLoading(true);
    });

    _messageController.clear();
    _scrollToBottom();

    final res = await APIService().chat(text);

    setState(() {
      appState.addMessage(ChatMessage(
        content: res,
        isUser: false,
      ));
      appState.setLoading(false);
    });
    _scrollToBottom();
  }

  void _ShowBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        );
      }
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Assistant'),
        backgroundColor: appState.selectedColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: appState.messages.isEmpty && !appState.isLoading
                ? Center(
                    child: Text(
                      "Let's start the conversation.",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 84, 84, 84)),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(25),
                    itemCount:
                        appState.messages.length + (appState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      // 最后一项是 loading 状态
                      if (appState.isLoading &&
                          index == appState.messages.length) {
                        return _buildThinkingBubble();
                      }
                      final message = appState.messages[index];
                      return _buildMessageBubble(message);
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildThinkingBubble() {
    final appState = Provider.of<AppState>(context, listen: true);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
        decoration: BoxDecoration(
          color: appState.selectedColor.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Thinking',
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 8),
            _buildDots(),
          ],
        ),
      ),
    );
  }

  Widget _buildDots() {
    return SizedBox(
      width: 30,
      height: 10,
      child: AnimatedDots(),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final appState = Provider.of<AppState>(context, listen: true);
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: message.isUser
              ? appState.selectedColor
              : appState.selectedColor.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.content,
          style: TextStyle(
            color: message.isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    final appState = Provider.of<AppState>(context, listen: true);
    return BottomAppBar(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      color: Color.fromARGB(255, 255, 252, 252),
      shadowColor: const Color.fromARGB(255, 94, 94, 94),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Input message...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide(color: appState.selectedColor)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.send, color: appState.selectedColor),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
