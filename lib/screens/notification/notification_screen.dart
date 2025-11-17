import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../services/notification_service.dart';

class NotificationScreen extends StatefulWidget {
  static const routeName = '/notifications';
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<AppNotification>> futureNotifications;

  @override
  void initState() {
    super.initState();
    futureNotifications = NotificationService.getNotifications();
  }

  Future<void> refresh() async {
    setState(() {
      futureNotifications = NotificationService.getNotifications();
    });
    await futureNotifications;
  }

  Widget _buildTile(AppNotification n) {
    return Dismissible(
      key: Key(n.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        bool ok = await NotificationService.deleteNotification(n.id);
        if (!ok) {
          // jika gagal, tampilkan pesan dan refresh ulang
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus notifikasi')),
          );
          refresh();
        } else {
          refresh();
        }
      },
      child: ListTile(
        tileColor: n.isRead ? Colors.white : Colors.blue.shade50,
        title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
        subtitle: Text(n.message),
        trailing: Text(n.createdAt, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        onTap: () async {
          if (!n.isRead) {
            bool ok = await NotificationService.markAsRead(n.id);
            if (ok) setState(() => futureNotifications = NotificationService.getNotifications());
          }
          // Optional: buka detail page here
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder<List<AppNotification>>(
          future: futureNotifications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Belum ada notifikasi')),
                ],
              );
            }
            final list = snapshot.data!;
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) => _buildTile(list[i]),
            );
          },
        ),
      ),
    );
  }
}
