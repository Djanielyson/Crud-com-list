import 'package:agenda_contatos/produto.dart';
import 'package:agenda_contatos/produto_page.dart';
import 'package:flutter/material.dart';

enum OrderOptions { orderaz, orderza }

class ProdutoListViewPage extends StatefulWidget {
  @override
  _ProdutoListViewPageState createState() => _ProdutoListViewPageState();
}

class _ProdutoListViewPageState extends State<ProdutoListViewPage> {
  ProdutoHelper helper = ProdutoHelper();

  List<Produto> produtos = List();

  @override
  void initState() {
    super.initState();

    _getAllProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: produtos.length,
          itemBuilder: (context, index) {
            return _produtoCard(context, index);
          }),
    );
  }

  Widget _produtoCard(BuildContext context, int index) {
    return GestureDetector(
      child: ListTile(
        title: Text("Nome: " + produtos[index].name ?? ""),
        subtitle: Text("Marca: " + produtos[index].marca ?? ""),
        trailing: Text("Preço: RS" + produtos[index].preco ?? ""),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(produto: produtos[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(
                              color: Colors.deepPurple, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helper.deleteProduto(produtos[index].id);
                          setState(() {
                            produtos.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showContactPage({Produto produto}) async {
    final recProduto = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Produto_Page(
                  produto: produto,
                )));
    if (recProduto != null) {
      if (produto != null) {
        await helper.updateProduto(recProduto);
      } else {
        await helper.saveProduto(recProduto);
      }
      _getAllProdutos();
    }
  }

  void _getAllProdutos() {
    helper.getAllProdutos().then((list) {
      setState(() {
        produtos = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        produtos.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        produtos.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
