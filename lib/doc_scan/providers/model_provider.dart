import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _prefsKey = 'selected_model';
const String defaultModel = 'gemini-3.1-pro';

const Map<String, String> availableModels = {
  'claude-opus-4-6': 'Claude Opus 4.6',
  'claude-sonnet-4-6': 'Claude Sonnet 4.6',
  'gemini-3-flash': 'Gemini 3 Flash',
  'gemini-3.1-pro': 'Gemini 3.1 Pro',
  'gpt-5.4': 'GPT 5.4',
  'mistral-ocr': 'Mistral OCR',
};

final selectedModelProvider =
    StateNotifierProvider<SelectedModelNotifier, String>(
  (ref) => SelectedModelNotifier(),
);

class SelectedModelNotifier extends StateNotifier<String> {
  SelectedModelNotifier() : super(defaultModel) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_prefsKey);
    if (saved != null && availableModels.containsKey(saved)) {
      state = saved;
    }
  }

  Future<void> setModel(String model) async {
    if (!availableModels.containsKey(model)) return;
    state = model;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, model);
  }
}

/// Reads the persisted model choice (SharedPreferences wins over in-memory state).
Future<String> resolveSelectedModel(WidgetRef ref) async {
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(_prefsKey);
  if (saved != null && availableModels.containsKey(saved)) {
    return saved;
  }
  return ref.read(selectedModelProvider);
}

