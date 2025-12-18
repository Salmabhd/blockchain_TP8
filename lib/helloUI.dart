import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'contract_linking.dart';

class HelloUI extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var contract = Provider.of<ContractLinking>(context);

    return Scaffold(
      appBar: AppBar(title: Text("Hello World DApp"), backgroundColor: Colors.teal),
      body: Center(
        child: contract.isLoading
            ? CircularProgressIndicator()
            : Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Hello", style: TextStyle(fontSize: 60)),
                    Text(contract.deployedName ?? "Unknown", style: TextStyle(fontSize: 60, color: Colors.cyan)),
                    SizedBox(height: 50),
                    TextField(controller: controller, decoration: InputDecoration(labelText: "Ton nom", border: OutlineInputBorder())),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20)),
                      onPressed: () {
                        if (controller.text.isNotEmpty) contract.setName(controller.text); controller.clear();
                      },
                      child: Text("Set Name", style: TextStyle(fontSize: 24)),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}