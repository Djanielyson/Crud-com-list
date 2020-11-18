import 'dart:async';

import 'package:agenda_contatos/produto.dart';
import 'package:flutter/material.dart';

GlobalKey<FormState> _keyForm = GlobalKey<FormState>();

// ignore: camel_case_types
class Produto_Page extends StatefulWidget {
  final Produto produto;

  Produto_Page({this.produto});

  @override
  _Produto_PageState createState() => _Produto_PageState();
}

// ignore: camel_case_types
class _Produto_PageState extends State<Produto_Page> {
  final _nameController = TextEditingController();
  final _marcaController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _precoController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Produto _editedProduto;

  @override
  void initState() {
    super.initState();

    if (widget.produto == null) {
      _editedProduto = Produto();
    } else {
      _editedProduto = Produto.fromMap(widget.produto.toMap());

      _nameController.text = _editedProduto.name;
      _marcaController.text = _editedProduto.marca;
      _quantidadeController.text = _editedProduto.quantidade;
      _precoController.text = _editedProduto.preco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(_editedProduto.name ?? "Novo Produto"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedProduto.name != null && _editedProduto.name.isNotEmpty) {
              Navigator.pop(context, _editedProduto);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.deepPurple,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                ),
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedProduto.name = text;
                  });
                },
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: _marcaController,
                decoration: InputDecoration(labelText: "Marca"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedProduto.marca = text;
                },
                keyboardType: TextInputType.name,
              ),
              TextField(
                controller: _precoController,
                decoration: InputDecoration(labelText: "Preço"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedProduto.preco = text;
                },
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: "Quantidade"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedProduto.quantidade = text;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
