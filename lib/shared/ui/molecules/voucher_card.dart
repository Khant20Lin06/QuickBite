import 'package:flutter/material.dart';
import 'package:quickbite/app/tokens.dart';
import 'package:quickbite/core/utils/material_symbol_mapper.dart';
import 'package:quickbite/features/home/domain/home_models.dart';

class VoucherCard extends StatelessWidget {
  const VoucherCard({
    super.key,
    required this.voucher,
    required this.onActionPressed,
    this.isApplied = false,
    this.isCopied = false,
  });

  final VoucherModel voucher;
  final VoidCallback? onActionPressed;
  final bool isApplied;
  final bool isCopied;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled =
        voucher.disabled || voucher.actionType == VoucherActionType.claimed;
    final actionText = _actionLabel();

    return Container(
      decoration: BoxDecoration(
        color: isDisabled
            ? (isDark ? const Color(0x991E293B) : const Color(0x99F8FAFC))
            : (isDark ? const Color(0xFF0F172A) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDisabled
              ? (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))
              : (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 92,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isDisabled
                  ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
                  : const Color(0x1AF1277B),
              border: Border(
                right: BorderSide(
                  color: isDisabled
                      ? (isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0))
                      : const Color(0x33F1277B),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  mapMaterialSymbol(voucher.iconName),
                  size: 32,
                  color: isDisabled
                      ? const Color(0xFF94A3B8)
                      : QBTokens.primary,
                ),
                const SizedBox(height: 4),
                Text(
                  voucher.disabled ? 'EXPIRED' : 'OFFER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDisabled
                        ? const Color(0xFF94A3B8)
                        : QBTokens.primary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.7,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          voucher.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDisabled
                                ? const Color(0xFF94A3B8)
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A)),
                          ),
                        ),
                      ),
                      if (voucher.badgeLabel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            voucher.badgeLabel!,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    voucher.description,
                    style: TextStyle(
                      color: isDisabled
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voucher.expiryLabel,
                              style: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              voucher.minSpendLabel,
                              style: const TextStyle(
                                color: QBTokens.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      FilledButton(
                        key: Key('voucher-action-${voucher.id}'),
                        onPressed: isDisabled ? null : onActionPressed,
                        style: FilledButton.styleFrom(
                          backgroundColor:
                              voucher.actionType == VoucherActionType.copyCode
                              ? Colors.white
                              : QBTokens.primary,
                          foregroundColor:
                              voucher.actionType == VoucherActionType.copyCode
                              ? QBTokens.primary
                              : Colors.white,
                          side: voucher.actionType == VoucherActionType.copyCode
                              ? const BorderSide(color: QBTokens.primary)
                              : BorderSide.none,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(999),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        child: Text(actionText),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _actionLabel() {
    if (voucher.disabled) {
      return 'Claimed';
    }
    if (voucher.actionType == VoucherActionType.apply) {
      return isApplied ? 'Applied' : 'Apply';
    }
    if (voucher.actionType == VoucherActionType.copyCode) {
      return isCopied ? 'Copied' : 'Copy Code';
    }
    return 'Claimed';
  }
}
