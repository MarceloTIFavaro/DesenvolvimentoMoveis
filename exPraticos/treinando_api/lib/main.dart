import 'package:flutter/material.dart';
import 'dart:convert'; // Para usar jsonDecode
import 'package:http/http.dart'; // Para chamadas HTTP

class TelaAfazeres extends StatefulWidget{
  const TelaAfazeres({super.key});


  @override 
  State<TelaAfazeres> createState() => _TelaAfazeresState();
}

class _TelaAfazeresState extends State<TelaAfazeres>{
  // 1. Declaramos uma variável para guardar nosso Future.
  late Future<List<Afazer>> _futureAfazeres;

  @override
  void initState(){
    super.initState();
    
  }
}





// ---SERVIÇO DE DADOS---
class AfazerService{
  // A função é um 'Future' porque é uma operação assíncrona.
  // Ela retornará uma lista de Afazeres no futuro.
  Future<List<Afazer>>buscarAfazer() async{
    // 1. Montamos a URL da API
    final url = Uri.parse('https://jsonplaceholder.typicode.com/todos');

    //  2.Fazemos a requisição GET e esperamos('await') pela resposta
    final response = await http.get(url);
    
    // 3. Verificamos se a requisição foi bem-sucedida (Status Code 200). 
    if(reponse.statusCode = 200){
    // 4. Se sucesso, decodificamos o corpo da resposta, que é uma String JSON.
    // O resultado é uma List<dynamic>, pois o JSON é uma lista de objetos.
      final List<dynamic> listaJson = jsonDecode(response.body);

    // 5. Usamos o método map() para converter cada item da listaJson
    // em um objeto Afazer, usando nosso construtor de fábrica fromJson.
    // O .toList() no final converte o resultado de volta para uma List
    return listaJson.map((json) => Afazer.fromJson(json)).toList();
    }else{
      // 6. Se a requisição falhou, lançamos uma exceção para que a UI possa tratar o erro.
      throw Exception('Falha ao carregar os afazeres da API.');

    }
  }
}



class Afazer{
  final int id;
  final String titulo;
  final bool completo;

  // Construtor padrão 
  const Afazer ({required this.id, required this.titulo, required this.completo});

  //Contrutor Construtor de fábrica 'fromJson'
  // Ele recebe um Map<String, dynamic> (resultado do jsonDecode)
  // e retorna uma instância da classe Afazer

  factory Afazer.fromJason(Map<String, dynamic>json){
    return Afazer(
      id: json['id'],
      titulo: json['title'],
      completo: json['completed'],
    );
  }
}