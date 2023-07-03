import 'dart:convert';

import 'package:e_wallet/models/tip_model.dart';
import 'package:e_wallet/services/auth_service.dart';
import 'package:e_wallet/shared/shared_values.dart';
import 'package:http/http.dart' as http;

class TipService {
  Future<List<TipModel>> getTips() async {
    try {
      final token = await AuthService().getToken();

      final res = await http.get(
        Uri.parse('$baseUrl/tips'),
        headers: {
          'Authorization': token,
        },
      );
      if (res.statusCode == 200) {
        return List<TipModel>.from(
          jsonDecode(res.body)['data'].map(
            (tips) => TipModel.fromJson(tips),
          ),
        ).toList();
      }
      throw jsonDecode(res.body)['message'];
    } catch (e) {
      rethrow;
    }
  }
}
