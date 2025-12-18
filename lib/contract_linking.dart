import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

class ContractLinking extends ChangeNotifier {
  final String _rpcUrl = "HTTP://127.0.0.1:7545";     // Émulateur Android
  final String _wsUrl = "HTTP://127.0.0.1:7545";

  final String _privateKey =
      "0xc6fb221f512a75638a562ecfd3c6371df6c030ccab210fe574be01d09db5c376";

  late Web3Client _client;
  bool isLoading = true;
  String deployedName = "Unknown";

  late DeployedContract _contract;
  late ContractFunction _yourName;
  late ContractFunction _setName;

  ContractLinking() {
    initialize();
  }

  Future<void> initialize() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    await loadContract();
    await loadName();
  }

  Future<void> loadContract() async {
    try {
      String abi = await rootBundle.loadString("src/artifacts/HelloWorld.json");
      final jsonAbi = jsonDecode(abi);

      final networkId = jsonAbi["networks"].keys.first;
      final address = jsonAbi["networks"][networkId]["address"];

      _contract = DeployedContract(
        ContractAbi.fromJson(jsonEncode(jsonAbi["abi"]), "HelloWorld"),
        EthereumAddress.fromHex(address),
      );

      _yourName = _contract.function("yourName");
      _setName = _contract.function("setName");
    } catch (e) {
      print("Erreur chargement contrat: $e");
    }
  }

  Future<void> loadName() async {
    try {
      final result = await _client.call(contract: _contract, function: _yourName, params: []);
      deployedName = result.isNotEmpty ? result[0].toString() : "Unknown";
    } catch (e) {
      deployedName = "Erreur lecture";
      print("Erreur lecture nom: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> setName(String name) async {
    if (name.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      final credentials = EthPrivateKey.fromHex(_privateKey);

      await _client.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: _contract,
          function: _setName,
          parameters: [name],
          maxGas: 100000,
        ),
        chainId: 1337,
      );

      await Future.delayed(const Duration(seconds: 8));
      await loadName();
    } catch (e) {
      print("Erreur transaction : $e");
      deployedName = "Échec transaction";
      isLoading = false;
      notifyListeners();
    }
  }
}