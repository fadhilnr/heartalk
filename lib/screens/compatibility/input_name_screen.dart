import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/theme.dart';
import '../../providers/compatibility_provider.dart';

class InputNameScreen extends StatefulWidget {
  final String? existingResultId;
  
  const InputNameScreen({
    super.key,
    this.existingResultId,
  });

  @override
  State<InputNameScreen> createState() => _InputNameScreenState();
}

class _InputNameScreenState extends State<InputNameScreen> {
  final _userNameController = TextEditingController();
  final _partnerNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    if (widget.existingResultId != null) {
      final provider = context.read<CompatibilityProvider>();
      final result = provider.getResultById(widget.existingResultId!);
      if (result != null) {
        _userNameController.text = result.userName;
        _partnerNameController.text = result.partnerName;
      }
    }
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _partnerNameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.push(
        '/compatibility/question',
        extra: {
          'userName': _userNameController.text,
          'partnerName': _partnerNameController.text,
          'existingResultId': widget.existingResultId,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRetake = widget.existingResultId != null;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 20 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isRetake ? 'Tes Ulang Kecocokan' : 'Kenali Lebih Dalam',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          isRetake 
                              ? 'Coba tes lagi dan lihat apakah ada perubahan'
                              : 'Isi nama kalian berdua untuk memulai tes kecocokan',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: AppColors.text.withValues(alpha: 0.6),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildInputField(
                    controller: _userNameController,
                    label: 'Nama Kamu',
                    hint: 'Masukkan nama kamu',
                    icon: Icons.person_outline,
                    delay: 200,
                    enabled: !isRetake,
                  ),
                  const SizedBox(height: 24),
                  _buildInputField(
                    controller: _partnerNameController,
                    label: 'Nama Pasangan',
                    hint: 'Masukkan nama pasangan kamu',
                    icon: Icons.favorite_outline,
                    delay: 400,
                    enabled: !isRetake,
                  ),
                  const SizedBox(height: 48),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: child,
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          isRetake ? 'Mulai Tes Ulang' : 'Mulai Tes',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required int delay,
    bool enabled = true,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + delay),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: Icon(icon, color: AppColors.primary),
              filled: true,
              fillColor: enabled ? Colors.white : Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.grey.withValues(alpha: 0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama tidak boleh kosong';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}