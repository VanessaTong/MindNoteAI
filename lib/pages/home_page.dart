import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/client.dart';
import 'client_detail_page.dart';

class HomePage extends StatelessWidget {
  final List<Client> clients = [
    Client(
      name: 'Alice Morgan',
      nextAppointment: DateTime.now().add(Duration(days: 3, hours: 20)),
      visits: 12,
      notes: [
        CaseNote(
          format: 'SOAP',
          date: DateTime(2024, 3, 11),
          duration: Duration(minutes: 50),
          summary:
              'Client showed significant improvement in anxiety management techniques. Discussed coping strategies for work-related stress. Homework assignment: daily meditation practice. Next session will focus on interpersonal relationship patterns.',
        ),
        CaseNote(
          format: 'DAP',
          date: DateTime(2024, 3, 4),
          duration: Duration(minutes: 45),
          summary:
              'Client reported improved sleep patterns. Explored relationship dynamics and triggers for tension with partner.',
        ),
      ],
    ),
    Client(
      name: 'John Davis',
      nextAppointment: DateTime.now().add(Duration(days: 4, hours: 18)),
      visits: 8,
      notes: [],
    ),
    Client(
      name: 'Maria Santos',
      nextAppointment:
          DateTime.now().add(Duration(days: 5, hours: 23, minutes: 30)),
      visits: 5,
      notes: [],
    ),
    Client(
      name: 'Robert Johnson',
      nextAppointment: DateTime.now().add(Duration(days: 6, hours: 19)),
      visits: 15,
      notes: [],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search clients...',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Clients',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  Text('${clients.length} clients',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: clients.length,
                itemBuilder: (context, index) {
                  final client = clients[index];
                  return _clientCard(context, client);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final today = DateTime.now();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)]),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Dr. Sarah Chen',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text(DateFormat('EEEE, MMM d, yyyy').format(today),
                      style: TextStyle(color: Colors.white70)),
                ],
              ),
              CircleAvatar(
                backgroundColor: Colors.white24,
                child: Text('SC',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('0', 'Today'),
              _statItem('0', 'This Week'),
              _statItem('4', 'Total Clients'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white70)),
      ],
    );
  }

  Widget _clientCard(BuildContext context, Client client) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ClientDetailPage(client: client)),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [Color(0xFF56CCF2), Color(0xFF2F80ED)]),
                ),
                alignment: Alignment.center,
                child: Text(_initials(client.name),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(client.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.calendar_today,
                            size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Text(
                            'Next: ${DateFormat.MMMd().add_jm().format(client.nextAppointment)}',
                            style: TextStyle(color: Colors.grey[700])),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Visit #${client.visits}',
                      style: TextStyle(
                          color: Color(0xFF2F80ED),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('Active', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.split(' ');
    return parts.map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
  }
}
