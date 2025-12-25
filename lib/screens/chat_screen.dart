import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/auth_controller.dart';
import '../controllers/language_controller.dart';
import '../controllers/data_controller.dart';
import '../models/chat_message.dart';
import '../widgets/custom_text_field.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;

  ChatScreen({required this.receiverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  List<ChatMessage> _messages = [];
  bool _isBlocked = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _checkBlockedStatus();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMessages() {
    final authController = Get.find<AuthController>();
    final dataController = Get.find<DataController>();
    final currentUserId = authController.currentUser.value?.id;
    
    if (currentUserId != null) {
      setState(() {
        _messages = dataController.getMessagesForChat(currentUserId, widget.receiverId);
      });
      _scrollToBottom();
    }
  }

  void _checkBlockedStatus() {
    final authController = Get.find<AuthController>();
    final currentUser = authController.currentUser.value;
    
    if (currentUser != null) {
      setState(() {
        _isBlocked = currentUser.blockedUserIds.contains(widget.receiverId);
      });
    }
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
    final languageController = Get.find<LanguageController>();
    final dataController = Get.find<DataController>();
    final receiverTutor = dataController.getTutorById(widget.receiverId);
    final receiverName = receiverTutor?.fullName ?? 'Unknown User';

    return Directionality(
      textDirection: languageController.isRTL.value 
          ? TextDirection.rtl 
          : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0xFF0768FF),
                backgroundImage: receiverTutor?.profilePhoto != null 
                    ? NetworkImage(receiverTutor!.profilePhoto!) 
                    : null,
                child: receiverTutor?.profilePhoto == null 
                    ? Icon(Icons.person, color: Colors.white, size: 20)
                    : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receiverName,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    if (receiverTutor != null)
                      Text(
                        receiverTutor.subjects.join(', '),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert, color: Colors.grey[700]),
              onPressed: () => _showChatOptions(languageController),
            ),
          ],
        ),
        body: Column(
          children: [
            if (_isBlocked)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border(
                    bottom: BorderSide(color: Colors.red[200]!),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.block, color: Colors.red[600], size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'You have blocked this user. Unblock to continue chatting.',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: _messages.isEmpty 
                  ? _buildEmptyState(languageController)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        return _buildMessageBubble(_messages[index]);
                      },
                    ),
            ),
            _buildMessageInput(languageController),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(LanguageController languageController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Start your conversation',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Send a message to begin chatting',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final authController = Get.find<AuthController>();
    final isMe = message.senderId == authController.currentUser.value?.id;
    final timeFormat = DateFormat('HH:mm');
    
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ..[
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF0768FF),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
            SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? Color(0xFF0768FF) : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: isMe ? Radius.circular(4) : Radius.circular(20),
                  bottomLeft: !isMe ? Radius.circular(4) : Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    timeFormat.format(message.timestamp),
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isMe) ..[
            SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF0768FF),
              child: Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMessageInput(LanguageController languageController) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attach_file, color: Colors.grey[600]),
            onPressed: _isBlocked ? null : () {
              // TODO: Implement file attachment
            },
          ),
          Expanded(
            child: CustomTextField(
              controller: _messageController,
              label: languageController.translate('type_message'),
              maxLines: null,
              enabled: !_isBlocked,
              onSubmitted: (value) => _sendMessage(),
            ),
          ),
          SizedBox(width: 8),
          GestureDetector(
            onTap: _isBlocked ? null : _sendMessage,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _isBlocked ? Colors.grey[300] : Color(0xFF0768FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isBlocked) return;

    final authController = Get.find<AuthController>();
    final dataController = Get.find<DataController>();
    final currentUserId = authController.currentUser.value?.id;

    if (currentUserId != null) {
      dataController.sendMessage(currentUserId, widget.receiverId, message);
      _messageController.clear();
      _loadMessages();
    }
  }

  void _showChatOptions(LanguageController languageController) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                _isBlocked ? Icons.person_add : Icons.block,
                color: _isBlocked ? Colors.green : Colors.red,
              ),
              title: Text(
                _isBlocked ? 'Unblock User' : 'Block User',
                style: TextStyle(
                  color: _isBlocked ? Colors.green : Colors.red,
                ),
              ),
              onTap: () {
                Get.back();
                _toggleBlock();
              },
            ),
            ListTile(
              leading: Icon(Icons.report, color: Colors.orange),
              title: Text('Report User'),
              onTap: () {
                Get.back();
                _showReportDialog(languageController);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.grey[700]),
              title: Text('Clear Chat'),
              onTap: () {
                Get.back();
                _clearChat();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleBlock() {
    final authController = Get.find<AuthController>();
    
    if (_isBlocked) {
      // Unblock logic would go here
      setState(() {
        _isBlocked = false;
      });
      Get.snackbar(
        'Unblocked',
        'User has been unblocked',
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } else {
      authController.blockUser(widget.receiverId);
      setState(() {
        _isBlocked = true;
      });
      Get.snackbar(
        'Blocked',
        'User has been blocked',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  void _showReportDialog(LanguageController languageController) {
    final _reportController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report User'),
        content: TextField(
          controller: _reportController,
          decoration: InputDecoration(
            labelText: 'Reason for reporting',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(languageController.translate('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Reported',
                'Report submitted successfully',
                backgroundColor: Colors.orange[100],
                colorText: Colors.orange[800],
              );
            },
            child: Text('Submit'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  void _clearChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Chat'),
        content: Text('Are you sure you want to clear all messages? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              setState(() {
                _messages.clear();
              });
              Get.snackbar(
                'Cleared',
                'Chat has been cleared',
                backgroundColor: Colors.grey[100],
                colorText: Colors.grey[800],
              );
            },
            child: Text('Clear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}