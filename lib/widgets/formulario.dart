import 'package:flutter/material.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {

  String dropdownValue = 'Pedidos';
  final GlobalKey<FormState> _formularioEstado = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formularioEstado,
        child: Column(
        children: [
          DropdownButton<String>(
            value:dropdownValue,
            icon: const Icon(Icons.arrow_drop_down_sharp),
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.black,
            ), 
            onChanged: (String? newValue){
              setState(() {
                dropdownValue=newValue!;
              });
            },
            items: const [
              DropdownMenuItem<String>(
                value: 'Pedidos',
                child: Text('Pedidos'),
              ),
              DropdownMenuItem<String>(
                value: 'Productos',
                child: Text('Productos'),
              ),
              DropdownMenuItem<String>(
                value: 'Clientes',
                child: Text('Clientes'),
              ),
            ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)
              
            ),
            child: TextFormField(
              validator:(value){

                if(value!.isEmpty){
                  return 'El NIT no puede estar vacio';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Nit',
                border: InputBorder.none),
            )
          ),
          Expanded(child: Container()),
          Container(
            width: double.infinity,
            child: ElevatedButton(onPressed: (){
              if(_formularioEstado.currentState!.validate()){
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enviando datos'))
                );
              }else{
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Datos invalidos'))
                );}
            },child: Text('Enviar')),
          )
        ],)),
    );
  }
}