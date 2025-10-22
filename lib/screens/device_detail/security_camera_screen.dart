import 'package:flutter/material.dart';
import 'package:smart_home_control/controllers/devices_controller.dart';
import 'package:smart_home_control/core/controller_provider.dart';
import 'package:smart_home_control/widgets/event_list_row.dart';

class SecurityCameraScreen extends StatelessWidget {
  const SecurityCameraScreen({super.key, this.deviceId});

  final String? deviceId;

  @override
  Widget build(BuildContext context) {
    final controller = ControllerScope.of(context).devices;
    final device = controller.findById(deviceId);
    return Scaffold(
      appBar: AppBar(title: const Text('CCTV Camera')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/room_living.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 220,
                child: Stack(
                  children: [
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text('Live', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: Row(
                        children: const [
                          _CameraAction(icon: Icons.videocam_outlined),
                          SizedBox(width: 12),
                          _CameraAction(icon: Icons.mic_none),
                          SizedBox(width: 12),
                          _CameraAction(icon: Icons.settings_outlined),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Playback History', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      EventListRow(
                        index: 0,
                        title: 'Camera Back Online',
                        time: '8:30AM',
                        duration: '06min20sec',
                      ),
                      EventListRow(
                        index: 1,
                        title: 'Person Spotted',
                        time: '7:10AM',
                        duration: '01min35sec',
                        badge: 'Alert',
                      ),
                      EventListRow(
                        index: 2,
                        title: 'Low Light Alert',
                        time: '6:20AM',
                        duration: '01min55sec',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraAction extends StatelessWidget {
  const _CameraAction({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: Colors.black87),
    );
  }
}
