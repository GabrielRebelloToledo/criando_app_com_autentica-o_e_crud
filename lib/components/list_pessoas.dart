import 'dart:io';
import 'package:auth_crud/models/pessoa.dart';
import 'package:auth_crud/provider/pessoas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListPessoa extends StatefulWidget {
  final Pessoa pessoa;

  const ListPessoa({Key? key, required this.pessoa}) : super(key: key);

  @override
  _ListPessoaState createState() => _ListPessoaState();
}

class _ListPessoaState extends State<ListPessoa> {
  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListTile(
                    title: Text(
                      'Nome: ' + widget.pessoa.name + '\n',
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      'Número de telefone: ' +
                          widget.pessoa.id +
                          '\nDecúbito Atual: ' +
                          widget.pessoa.id,
                      style: TextStyle(fontSize: 16),
                    ),
                    isThreeLine: true,
                    trailing: Container(
                        padding: EdgeInsets.only(left: 3),
                        width: 130,
                        child: Row(children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            color: Colors.green,
                            onPressed: () {
                              /* Navigator.of(context).pushNamed(
                                Routes.EDITAR_CADASTRO,
                                arguments: widget.pessoa,
                              ); */
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () {
                              showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Excluir Pessoa'),
                                  content: Text('Tem certeza?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Não'),
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(false),
                                    ),
                                    TextButton(
                                      child: Text('Sim'),
                                      onPressed: () =>
                                          Navigator.of(ctx).pop(true),
                                    ),
                                  ],
                                ),
                              ).then((value) async {
                                if (value ?? false) {
                                  try {
                                    await Provider.of<ProductList>(
                                      context,
                                      listen: false,
                                    ).removeProduct(widget.pessoa);
                                  } on HttpException catch (error) {
                                    msg.showSnackBar(
                                      SnackBar(
                                        content: Text(error.toString()),
                                      ),
                                    );
                                  }
                                }
                              });
                            },
                          ),
                        ]))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
