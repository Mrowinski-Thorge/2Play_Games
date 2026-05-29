import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/connectivity_service.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  bool _isEditingName = false;

  @override
  void initState() {
    super.initState();
    final connService = Provider.of<ConnectivityService>(context, listen: false);
    _nameController = TextEditingController(text: connService.myUsername);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveName() {
    if (_nameController.text.trim().isNotEmpty) {
      Provider.of<ConnectivityService>(context, listen: false)
          .setUsername(_nameController.text.trim());
      setState(() {
        _isEditingName = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final connService = Provider.of<ConnectivityService>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F0B1E), Color(0xFF130A29), Color(0xFF0F0B1E)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF4F6FB), Color(0xFFE9EEF6), Color(0xFFF7F8FC)],
                ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Nav Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Einstellungen',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    // Section: Profile
                    _buildSectionHeader(context, 'PROFIL'),
                    const SizedBox(height: 12),
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(colors: AppTheme.primaryGradient),
                                ),
                                child: const Center(
                                  child: Icon(Icons.sports_esports_rounded, color: Colors.white, size: 28),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _isEditingName
                                    ? TextField(
                                        controller: _nameController,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                        autofocus: true,
                                        decoration: InputDecoration(
                                          hintText: 'Spielername',
                                          isDense: true,
                                          border: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: isDark ? Colors.white54 : Colors.black54,
                                            ),
                                          ),
                                        ),
                                        onSubmitted: (_) => _saveName(),
                                      )
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            connService.myUsername,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          const Text(
                                            'Eigener Anzeigename',
                                            style: TextStyle(fontSize: 12, color: Colors.grey),
                                          ),
                                        ],
                                      ),
                              ),
                              IconButton(
                                icon: Icon(
                                  _isEditingName ? Icons.check_circle_outline_rounded : Icons.edit_rounded,
                                  color: const Color(0xFF00F2FE),
                                ),
                                onPressed: _isEditingName ? _saveName : () => setState(() => _isEditingName = true),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 28),

                    // Section: Design
                    _buildSectionHeader(context, 'DESIGN'),
                    const SizedBox(height: 12),
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                color: isDark ? const Color(0xFF00F2FE) : const Color(0xFF8A2387),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Dunkles Design (Dark Mode)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          CupertinoSwitch(
                            activeColor: const Color(0xFF8A2387),
                            trackColor: Colors.grey.withOpacity(0.3),
                            value: connService.isDarkMode,
                            onChanged: (val) => connService.setDarkMode(val),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

                    const SizedBox(height: 28),

                    // Section: Connectivity
                    _buildSectionHeader(context, 'NETZWERK & VERBINDUNG'),
                    const SizedBox(height: 12),
                    GlassContainer(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.cell_tower_rounded,
                                    color: connService.mode == AppConnectivityMode.real
                                        ? const Color(0xFF00F2FE)
                                        : const Color(0xFFFF007F),
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    'Verbindungsmodus',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Toggle Segments
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.black38 : Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => connService.setConnectivityMode(AppConnectivityMode.simulated),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: connService.mode == AppConnectivityMode.simulated
                                            ? (isDark ? const Color(0xFF1B1437) : Colors.white)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: connService.mode == AppConnectivityMode.simulated && !isDark
                                            ? AppTheme.softShadow
                                            : [],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Demo (Simuliert)',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: connService.mode == AppConnectivityMode.simulated
                                                ? (isDark ? Colors.white : Colors.black87)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => connService.setConnectivityMode(AppConnectivityMode.real),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: connService.mode == AppConnectivityMode.real
                                            ? (isDark ? const Color(0xFF1B1437) : Colors.white)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: connService.mode == AppConnectivityMode.real && !isDark
                                            ? AppTheme.softShadow
                                            : [],
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Bluetooth & Wi-Fi',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: connService.mode == AppConnectivityMode.real
                                                ? (isDark ? Colors.white : Colors.black87)
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            connService.mode == AppConnectivityMode.real
                                ? 'Verwendet Bluetooth und lokales Wi-Fi, um echte Spieler in deiner Umgebung zu finden. Benötigt zwei physische Geräte.'
                                : 'Simuliert andere Spieler und lässt dich mit einer lokalen KI üben. Perfekt zum Ausprobieren ohne zweites Gerät!',
                            style: const TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      title,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: isDark ? Colors.white60 : Colors.grey[700],
      ),
    );
  }
}
