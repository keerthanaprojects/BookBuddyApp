import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_page.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDarkMode = false;
  String usernameCheck = "NoUserName";
  bool isButtonEnables = true;
  List<Book> books = [
    Book(1, 'Silent Patient', 'Alex Michaelides', true,
        'books/silent_patient.jpg', 10, 10),
    Book(2, 'The Outsider', 'Stephen King', false, 'books/the_outsider.jpg', 0,
        0),
    Book(3, 'The Sum of All Things', 'Nicole', true,
        'books/the_sum_of_all_things.jpg', 20, 20),
    Book(4, 'Dead Body Disposal', 'Jon Athan', true,
        'books/deadbody_disposal.jpg', 15, 15),
    Book(5, 'Clap When You Land', 'Elizabeth Acevedo', true,
        'books/clap_when_you_land.jpg', 12, 12),
    Book(6, 'Can Cookie Change the World', 'Rhonda Bolling', true,
        'books/can_cookie_change_the_world.jpg', 19, 19),
    Book(7, 'Jujutsu Kaisen', 'Gege Akutami', true, 'books/jujutsu-kaisen.jpg',
        10, 10),
    Book(8, 'Demon Slayer', 'Koyoharu Gotouge', false, 'books/demon_slayer.jpg',
        0, 0),
    Book(9, 'Krabat', 'Otfried Preussler', true, 'books/krabat.jpeg', 25, 25),
    Book(10, 'Love Me Back', 'Meritt Tierce', false, 'books/love_me_back.jpg',
        0, 0),
    Book(
        11, 'One Piece', 'Rhonda Bolling', true, 'books/one_piece.jpg', 10, 10),
    Book(12, 'Something Nasty in the Woodshed', 'Carlie Mortdecai', true,
        'books/something_nasty_in_the_woodshed.jpg', 10, 10),
    Book(13, 'Tess of Road', 'Rachel Hartman', true, 'books/tess_of_road.jpg',
        10, 10),
    Book(14, 'The Last Four Things', 'Paul Hoffman', false,
        'books/the_last_four_things.jpg', 0, 0),
    Book(15, 'The Lives We Lost', 'Megan Crewe', true,
        'books/the_lives_we_lost.jpg', 10, 10),
    Book(16, 'Where the Light Enters', 'Sara Donati', true,
        'books/where_the_light_enters.jpg', 10, 10),
  ];
  List<Book> filteredBooks = [];
  TextEditingController searchController = TextEditingController();
  Color containerBackgroundColor = Color.fromRGBO(225, 240, 218, 1);

  @override
  void initState() {
    super.initState();
    filteredBooks = books;
    containerBackgroundColor =
        isDarkMode ? Colors.grey[900]! : containerBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor:
              isDarkMode ? Colors.grey[900] : containerBackgroundColor,
          title: Row(
            children: [
              Icon(Icons.book),
              SizedBox(width: 8),
              Text("Book Buddy"),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                usernameCheck != "NO USERNAME"
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(isDarkMode: isDarkMode)))
                    : Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
              },
            ),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
                _changeTheme();
              },
            ),
          ],
        ),
        body: Container(
          color: containerBackgroundColor,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                style: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'Search by Title or Author',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              searchController.clear();
                              filteredBooks = books;
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _filterBooks(value);
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            ListTile(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              leading: Container(
                                width: 60,
                                height: 80,
                                child: Image.asset(
                                  filteredBooks[index].imageUrl,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              title: Text(
                                filteredBooks[index].title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Author: ${filteredBooks[index].author}',
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Availability: ${filteredBooks[index].isAvailable ? "Available" : "Not Available"}',
                                  ),
                                  Text(
                                      'No of Books: ${filteredBooks[index].noBooks}'),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  onPressed: filteredBooks[index].isAvailable
                                      ? () {
                                          _onLoanButtonPressed(
                                              filteredBooks[index]);
                                        }
                                      : null,
                                  child: Text('Loan'),
                                ),
                                ElevatedButton(
                                  onPressed: filteredBooks[index].noBooks <
                                          filteredBooks[index].maxNoBooks
                                      ? () {
                                          _onAcceptButtonPressed(
                                              filteredBooks[index]);
                                        }
                                      : null,
                                  child: Text('Accept'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      usernameCheck = pref.getString('username') ?? "NO USERNAME";
    });
  }

  Future<void> setNoBooksInStorage(Book book, int noBooks) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt('${book.id}', noBooks);
    debugPrint("Updated no of books for ${book.title}: " +
        pref.getInt('${book.id}').toString());
  }

  void _filterBooks(String query) {
    setState(() {
      filteredBooks = books
          .where((book) =>
              book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _changeTheme() {
    setState(() {
      containerBackgroundColor =
          isDarkMode ? Colors.grey[900]! : Color.fromRGBO(225, 240, 218, 1);
    });
  }

  Future<void> _onLoanButtonPressed(Book filteredBook) async {
    debugPrint(filteredBook.id.toString());
    debugPrint("Hi: " + (filteredBook.noBooks - 1).toString());
    if (filteredBook.noBooks > 0) {
      setState(() {
        filteredBook.setNoOfBooks(filteredBook.noBooks - 1);
      });
    } else {
      setState(() {
        filteredBook.setAvailability(false);
      });
    }
  }

  void _onAcceptButtonPressed(Book filteredBook) {
    debugPrint(filteredBook.author);
    if (filteredBook.noBooks < filteredBook.maxNoBooks) {
      setState(() {
        filteredBook.setNoOfBooks(filteredBook.noBooks + 1);
        filteredBook.setAvailability(true);
      });
    } else if (filteredBook.noBooks > 0) {
      setState(() {
        filteredBook.setAvailability(true);
      });
    }
  }
}

class Book {
  final int id;
  final String title;
  final String author;
  bool isAvailable;
  final String imageUrl;
  int noBooks;
  final maxNoBooks;
  bool isButtonEnabled = true;
  Book(this.id, this.title, this.author, this.isAvailable, this.imageUrl,
      this.noBooks, this.maxNoBooks);
  void setNoOfBooks(int noBooks) {
    this.noBooks = noBooks;
  }

  void setAvailability(bool isAvailable) {
    this.isAvailable = isAvailable;
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Login Page"),
      ),
    );
  }
}
