import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ngdemo23/presentation/bloc/home_bloc.dart';
import 'package:ngdemo23/presentation/bloc/home_state.dart';
import 'package:ngdemo23/presentation/widgets/item_gemini_message.dart';
import 'package:ngdemo23/presentation/widgets/item_user_message.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    homeBloc = context.read<HomeBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state){
          return Container(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: Column(
              children: [

                SizedBox(
                  height: 45,
                  child: Image(
                    image: AssetImage('assets/images/gemini_logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: homeBloc.messages.length,
                    itemBuilder: (context, index) {
                      var message = homeBloc.messages[index];

                      if (message.isMine!) {
                        return itemOfUserMessage(message);
                      }else {
                        return itemOfGeminiMessage(message);
                      }
                    },
                ),
                ),
                SizedBox(
                  height: 10,

                ),
                Container(
                  margin: const EdgeInsets.only(right: 20, left: 20),
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: homeBloc.textEditingController,
                              maxLines: null,
                              style: TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Message',
                                hintStyle: TextStyle(color: Colors.grey),
                            ),
                           ),
                          ),
                          IconButton(
                            onPressed: () async {},
                            icon: const Icon(
                              Icons.attach_file,
                              color: Colors.grey,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              homeBloc.askToGemini();
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
