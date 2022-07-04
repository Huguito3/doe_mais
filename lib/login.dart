import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:projeto_mobile/cadastro.dart';
import 'package:http/http.dart';
import 'package:projeto_mobile/models/campanhas.dart';
import 'package:projeto_mobile/produtos.dart';

import 'models/produto.dart';

class Login extends StatelessWidget {
  final Function loginF;
  Login(this.loginF);

  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();

    void _navegaCadastro() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Cadastro()),
      );
    }

    void _login() async {
      final enteredEmail = _emailController.text;
      final enteredPassword = _passwordController.text;
      // int.parse(_ageController.text.isEmpty ? '0' : _ageController.text);
      if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Favor preencher todos os campos!'),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      } else {
        String api = 'https://apl-back-doe-mais-ong.herokuapp.com/api/login';
        Response response = await post(
          Uri.parse(api),
          headers: <String, String>{'Content-Type': 'application/json'},
          body: jsonEncode(<String, String>{
            'email': enteredEmail,
            'password': enteredPassword
          }),
        );
        print(response.body);
        if (response.statusCode == 200) {
          var _token = jsonDecode(response.body);
          var _tokenObtido = _token['token'];
          // loginF(true);
          String apiP =
              'https://apl-back-doe-mais-ong.herokuapp.com/api/campanha?desde=0';
          Response responseProdutos = await get(
            Uri.parse(apiP),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'x-token': _tokenObtido
            },
          );
          print(responseProdutos.body);
          var tagObjsJson =
              jsonDecode(responseProdutos.body)['campanhas'] as List;
          List<Campanhas> tagObjs = tagObjsJson
              .map((tagJson) => Campanhas.fromJson(tagJson))
              .toList();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Produtos(tagObjs)),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Login ou senha inválido(a)!'),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 80,
          child: Text('DOE + MAIS',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          alignment: Alignment.center,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.blue.shade100,
                border: OutlineInputBorder(),
                labelText: 'E-mail',
                prefixIcon: Icon(Icons.mail),
              ),
              keyboardType: TextInputType.emailAddress),
          alignment: Alignment.center,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.blue.shade100,
              border: OutlineInputBorder(),
              labelText: 'Senha',
              prefixIcon: Icon(Icons.key),
            ),
            obscureText: true,
          ),
          alignment: Alignment.topCenter,
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: ElevatedButton(
              onPressed: _login,
              child: Text('Entrar'),
              // style: ElevatedButton.styleFrom(
              //   primary: Colors.blue,
              //   onPrimary: Colors.blue,
              //   minimumSize: const Size.fromHeight(50), // NEW
              // ),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.purple),
                  foregroundColor: MaterialStateProperty.all(Colors.white))),
        ),
        Container(
          height: 150,
          margin: EdgeInsets.only(top: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Ainda não é cadastrado?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextButton(
                  onPressed: _navegaCadastro,
                  child: Text('CADASTRE-SE'),
                  style: ButtonStyle(
                      // backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.purple)))
            ],
          ),
          alignment: Alignment.bottomCenter,
        )
      ],
    );
  }
}
