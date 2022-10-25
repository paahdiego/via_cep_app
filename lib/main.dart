import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:via_cep/address_model.dart';
import 'package:via_cep/address_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final cepController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {
      "#": RegExp(r'[0-9]'),
    },
  );

  AddressModel? address;

  String? error;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Via Cep APP",
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: cepController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [cepMask],
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length != 9) {
                        return "Digite um Cep Válido";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "CEP",
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    address = null;
                    error = null;
                  });
                  if (formKey.currentState!.validate()) {
                    final addressRepository = AddressRepository();

                    try {
                      address = await addressRepository.getAddress(
                        cep: cepController.text,
                      );
                      setState(() {});
                    } catch (e) {
                      error = e.toString();

                      setState(() {});
                    }
                  }
                },
                child: const Text("Buscar CEP"),
              ),
              if (address != null) Text(address.toString()),
              if (error != null) Text(error.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
