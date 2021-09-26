import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:auth_crud/models/pessoa.dart';
import 'package:flutter/material.dart';

class PessoaProvider with ChangeNotifier {
  static const _url =
      "https://flutterauth-7fd97-default-rtdb.firebaseio.com/pacientes";
  final String _token;
  final String _userId;
  final String statusPaciente = "Alta";
  final String statusPacienteEditado = 'Ativo';

  PessoaProvider([this._token = '', this._dados = const [], this._userId = '']);

  List<Pessoa> _dados = [];
  List<Pessoa> get dados => [..._dados];

  int get dadosCount {
    return dados.length;
  }

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data['id'] != null;

    final product = Pessoa(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      nome: data['name'] as String,
    );

    if (hasId) {
      return updatePaciente(product);
    } else {
      return createPaciente(product);
    }
  }

  //CREATE
  Future<void> createPaciente(Pessoa newPaciente) async {
    final response = await http.post(
      //o ?auth=$_token serve para encaminhar ao backend a solicitação do token, informando que esta autenticado
      Uri.parse("$_url/$_userId.json?auth=$_token"),
      body: json.encode({
        'nome': newPaciente.nome,
      }),
    );

    _dados.add(Pessoa(
      id: json.decode(response.body)['name'],
      nome: newPaciente.nome,
    ));
    notifyListeners();
  }

  // UPDATE
  Future<void> updatePaciente(Pessoa paciente) async {
    final i = _dados.indexWhere((pac) => pac.id == paciente.id);
    if (i >= 0) {
      final response = await http.put(
          Uri.parse("$_url/$_userId/${paciente.id}.json?auth=$_token"),
          body: json.encode({
            'nome': paciente.nome,
          }));
      _dados[i] = paciente;
      notifyListeners();
    }
  }

  //Alta do paciente
  Future<void> altaPaciente(Pessoa paciente) async {
    _dados.remove(paciente);
    notifyListeners();
    final response = await http.put(
        Uri.parse(
          '$_url/$_userId/${paciente.id}.json?auth=$_token',
        ),
        body: json.encode({
          'nome': paciente.nome,
        }));
  }

  // READ
  Future<void> loadAllpacientes() async {
    _dados.clear();

    final response = await http.get(
      Uri.parse("$_url/$_userId.json?auth=$_token"),
    );
    if (response.body == 'null') return;

    Map<String, dynamic> data = jsonDecode(response.body);
    data.forEach((pacienteId, pacienteData) {
      _dados.add(Pessoa(
        id: pacienteId,
        nome: pacienteData['nome'],
      ));
    });
    notifyListeners();
  }

  // DELETE
  Future<void> deletePaciente(Pessoa paciente) async {
    final i = _dados.indexWhere((pac) => pac.id == paciente.id);
    if (i >= 0) {
      final paciente = _dados[i];
      _dados.remove(paciente);
      notifyListeners();
      final response = await http
          .delete(Uri.parse("$_url/$_userId/${paciente.id}.json?auth=$_token"));
    }
  }
}
