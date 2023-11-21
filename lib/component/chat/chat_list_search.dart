import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.05,
          child: const TextField(
            cursorColor: Color.fromARGB(255, 27, 27, 27),
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              suffixIconColor: Color.fromARGB(255, 27, 27, 27),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 27, 27, 27),
                ),
              ),
            ),
          ),
        ),
        //IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
      ],
    );
  }
}
