import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'standard_zakat_rule.dart';
import 'zakat_rule.dart';

part 'zakat_rule_provider.g.dart';

@riverpod
ZakatRule zakatRule(Ref ref) => StandardZakatRule();
