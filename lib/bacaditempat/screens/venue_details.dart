import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:literalink/authentication/models/user.dart';
import 'package:literalink/bacaditempat/models/book_venue.dart';
import 'package:literalink/bacaditempat/models/venue.dart';
// import 'package:literalink/bacaditempat/screens/venue_page.dart';
// import 'package:literalink/homepage/detail_book.dart';
import 'package:literalink/homepage/home_page.dart';
import 'package:literalink/homepage/models/fetch_book.dart';
// import 'package:literalink/homepage/home_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';


class VenueDetail extends StatefulWidget {
final Venue venue;
const VenueDetail({super.key, required this.venue});


@override
State<VenueDetail> createState() => _VenueDetailState();
}


class _VenueDetailState extends State<VenueDetail> {
static const String baseUrl =
    'https://literalink-e03-tk.pbp.cs.ui.ac.id/bacaditempat';


Set<String> categories = {"All"};
String selectedCategory = "All";
String? selectedCategoryBtn;


Future<List<BookVenue>> fetchAvailableBookVenue() async {
  var url = Uri.parse('$baseUrl/get-product-available/${widget.venue.pk}/');
  var response =
      await http.get(url, headers: {"Content-Type": "application/json"});


  if (response.statusCode == 200) {
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    List<BookVenue> listBook = [];


    for (var d in data) {
      if (d != null) {
    
        BookVenue book = BookVenue.fromJson(d);


        listBook.add(book);
        if (book.fields.categories != "None") {
          categories.add(book.fields.categories);
        }


      }
    }
    return listBook;
  }


  else {
    throw Exception('Failed to fetch available books');
  }
}




Future<List<BookVenue>> fetchNotAvailableBookVenue() async {
 var url = Uri.parse('$baseUrl/get-product-notavailable/${widget.venue.pk}/');
 var response = await http.get(url, headers: {"Content-Type": "application/json"});


 if (response.statusCode == 200) {
   var data = jsonDecode(utf8.decode(response.bodyBytes));
   List<BookVenue> listBook = [];


   for (var d in data) {
     if (d != null) {
       BookVenue book = BookVenue.fromJson(d);
      
       // Tambahkan pengecekan username pengguna
       // if (book.fields.user == loggedInUser.username) {
         // Tambahkan atribut returnable dengan nilai true
         // book.fields.returnBook = true;
        


         listBook.add(book);
         if (book.fields.categories != "None") {
           categories.add(book.fields.categories);
         // }
       }
     }
   }
   // print(listBook);
   return listBook;
 }
    else {
   throw Exception('Failed to fetch unavailable books');
 }
}




Future<List<Book>> fetchItem() async {
   var url = Uri.parse('$baseUrl/show_json/');
   var response =
       await http.get(url, headers: {"Content-Type": "application/json"});


   var data = jsonDecode(utf8.decode(response.bodyBytes));
   List<Book> listBook = [];


   for (var i in data) {
     if (i != null) {
       Book bookDetail = Book.fromJson(i);
       listBook.add(bookDetail);
       categories.add(bookDetail.fields.categories);
     }
   }
   return listBook;
 }




void setSelectedCategory(String category) {
  setState(() => selectedCategory = category);
}






@override
Widget build(BuildContext context) {
  final request = context.watch<CookieRequest>();
  return Scaffold(
    backgroundColor: const Color(0xFFEEF5ED),
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFA8A8A8),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.venue.fields.placeName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 25, color: Color(0xFF252525)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: const Color(0xFFFFFFFF)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                          "https://literalink-e03-tk.pbp.cs.ui.ac.id/media/${widget.venue.fields.mapLocation}/"),
                    ),
                  ),
                  const SizedBox(height: 26),
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/images/Time Circle.svg",
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Open ${widget.venue.fields.venueOpen}",
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.venue.fields.placeName,
                    style: const TextStyle(
                        fontSize: 25, color: Color(0xFF252525)),
                  ),
                  SizedBox(
                    width: 300,
                    child: Text(
                      widget.venue.fields.address,
                      style: const TextStyle(color: Color(0xFF7C7C7C)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 130,
                        height: 115,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFE6F3EC)),
                                  child: const Icon(
                                    Icons.arrow_upward_rounded,
                                    color: Color(0xFF018845),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Rentable",
                                  style: TextStyle(
                                      color: Color(0xFF018845),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              widget.venue.fields.rentBook.toString(),
                              style: const TextStyle(
                                  fontSize: 35,
                                  color: Color(0xFF018845),
                                  fontWeight: FontWeight.bold),
                            ),
                            const Text(
                              "Books",
                              style: TextStyle(
                                  color: Color(0xFF018845), fontSize: 16),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 21),
                      Container(
                        width: 130,
                        height: 115,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFFFFF0ED)),
                                  child: const Icon(
                                    Icons.arrow_downward_rounded,
                                    color: Color(0xFFEB6645),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Returnable",
                                  style: TextStyle(
                                      color: Color(0xFFEB6645),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Text(
                              widget.venue.fields.returnBook.toString(),
                              style: const TextStyle(
                                  color: Color(0xFFEB6645),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 35),
                            ),
                            const Text(
                              "Books",
                              style: TextStyle(
                                  color: Color(0xFFEB6645),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
           InkWell(
             onTap: () => showModalBottomSheet(
               context: context,
               builder: (BuildContext context) {
                 return SafeArea(
                   child: SizedBox(
                     width: MediaQuery.of(context).size.width,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Container(
                           padding: const EdgeInsets.all(8.0),
                           child: const Text(
                             "Data Booking Buku",
                             style: TextStyle(fontSize: 20),
                           ),
                         ),
                         Expanded(
                           child: Align(
                             child: FutureBuilder(
                               // Ganti dengan fungsi yang sesuai untuk mengambil data booking buku
                               future: fetchNotAvailableBookVenue(),
                               builder: (context, snapshot) {
                                 if (snapshot.connectionState ==
                                     ConnectionState.waiting) {
                                   return const Center(
                                     child: CircularProgressIndicator(),
                                   );
                                 } else if (snapshot.hasError) {
                                   return Text('Error: ${snapshot.error}');
                                 } else if (!snapshot.hasData) {
                                   return const Text("Tidak ada data item.");
                                 } else {
                                   // Filter buku berdasarkan nama pengguna yang sedang login
                                   final List<BookVenue> userBooks = snapshot.data!
                                       .where((book) =>
                                           book.fields.username == loggedInUser.username)
                                       .toList();


                                   if (userBooks.isEmpty) {
                                     return const Text("Anda tidak memiliki buku yang dibooking.");
                                   }


                                   return SingleChildScrollView(
                                     child: Column(
                                       children: userBooks
                                           .map<Widget>((book) => Container(
                                                 width: 200,
                                                 margin: const EdgeInsets.symmetric(
                                                     horizontal: 10, vertical: 20),
                                                 child: ClipRRect(
                                                   borderRadius: BorderRadius.circular(10),
                                                   child: Material(
                                                     child: Column(
                                                       children: [
                                                         Image.network(
                                                           book.fields.thumbnail,
                                                         ),
                                                         Text(book.fields.title),
                                                         Text(book.fields.displayAuthors),
                                                         //  DefaultTextStyle(
                                                         //   style: const TextStyle(
                                                         //     fontSize: 10, // Sesuaikan dengan ukuran font yang Anda inginkan
                                                         //   ),
                                                         //   child: Text(
                                                         //     "Peminjam: ${book.fields.username}",
                                                         //     style: const TextStyle(
                                                         //       fontWeight: FontWeight.bold, // Ini membuat teks menjadi tebal (bold)
                                                         //     ),
                                                         //   ),
                                                         // ),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                final response = await request
                                                                    .postJson(
                                                                        "https://literalink-e03-tk.pbp.cs.ui.ac.id/bacaditempat/return_book_flutter/${widget.venue.pk}/${book.pk}/",
                                                                        jsonEncode(<String,
                                                                            String>{
                                                                          'book_id':
                                                                              book.fields.bookId,
                                                                          'title':
                                                                              book.fields.title,
                                                                          'authors':
                                                                              book.fields.authors,
                                                                          'display_authors':
                                                                              book.fields.displayAuthors,
                                                                          'description':
                                                                              book.fields.description,
                                                                          'categories':
                                                                              book.fields.categories,
                                                                          'thumbnail':
                                                                              book.fields.thumbnail,
                                                                        }));
                                                                if (response[
                                                                        "status"] ==
                                                                    'success') {
                                                                     String user = loggedInUser.username;
                                                                     String message = "Terimakasih $user telah mengembalikan buku!";
                                                                  // ignore: use_build_context_synchronously
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                           SnackBar(
                                                                    content: Text(message)),
                                                                  );


                                                                  // ignore: use_build_context_synchronously
                                                                  Navigator
                                                                      .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            const HomePage()),
                                                                  );
                                                                }
                                                              },
                                                              child: const Text(
                                                                  "Kembalikan")),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ));
                  }),
              child: Container(
                decoration: const BoxDecoration(color: Color(0xFFFFDBDB)),
                child: const Text("List Booking"),
              ),
            ),
            const SizedBox(height: 24),
            buildCategoryList(),
            const SizedBox(height: 10),
            buildBookList(request)
          ],
        ),
      ),
    ),
  );
}




Widget buildBookList(request) {
  return FutureBuilder<List<BookVenue>>(
    future: fetchAvailableBookVenue(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error} alskdjl');
      } else if (!snapshot.hasData) {
        return const Text("Tidak ada data item.");
      } else {
        return Column(
          children: snapshot.data!
              .where((book) =>
                  selectedCategory == "All" ||
                  book.fields.categories == selectedCategory)
              .map<Widget>((book) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    padding: const EdgeInsets.all(20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Material(
                        color: const Color(0xFFFFFFFF),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child:
                                        Image.network(book.fields.thumbnail),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 18),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: const Color(0xFFEB6645)),
                                          child: Text(
                                            book.fields.categories,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          book.fields.title,
                                          style: const TextStyle(
                                            color: Color(0xFF252525),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          book.fields.displayAuthors,
                                          style: TextStyle(
                                              color: const Color(0xFF252525)
                                                  .withOpacity(0.6)),
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              color: const Color(0xFFDAE9D8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 if (loggedInUser.role == 'M') // Add this line
                                  InkWell(
                                    onTap: () async {
                                      final response = await request.postJson(
                                          "https://literalink-e03-tk.pbp.cs.ui.ac.id/bacaditempat/rent_book_flutter/${book.pk}/",
                                          jsonEncode(<String, String>{
                                            'book_id': book.fields.bookId,
                                            'title': book.fields.title,
                                            'authors': book.fields.authors,
                                            'display_authors':
                                                book.fields.displayAuthors,
                                            'description':
                                                book.fields.description,
                                            'categories':
                                                book.fields.categories,
                                            'thumbnail':
                                                book.fields.thumbnail,
                                            'username': loggedInUser.username,
                                            'venue_id':
                                                widget.venue.pk.toString(),
                                          }));
                                      if (response["status"] == 'success') {
                                        // ignore: use_build_context_synchronously
                                        String user = loggedInUser.username;
                                        String message = "$user telah berhasil melakukan Booking!";
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(message)), 
                                        );
                                        // ignore: use_build_context_synchronously
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 36),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: const Color(0xFF005F3D)),
                                      child: const Text(
                                        "Pinjam",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () => print('gws'),
                                   //  async {
                                   //   Navigator.of(context).push(
                                   //     MaterialPageRoute(
                                   //       builder: (context) => DetailBookPage(book: book),
                                   //     ),
                                   //   );
                                   // },
                                    child: ClipRRect(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 44),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFBAD4C2),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: const Text(
                                          "Lihat",
                                          style: TextStyle(
                                              color: Color(0xFF005F3D),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        );
      }
    },
  );
 }




Widget buildCategoryList() {
  return FutureBuilder<List<BookVenue>>(
    future: fetchAvailableBookVenue(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData ||
          snapshot.data!.isEmpty ||
          categories.isEmpty) {
        return const Text('Tidak ada data kategori');
      } else {
        return SizedBox(
          height: 20,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              String category = categories.elementAt(index);
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () => setSelectedCategory(category),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == category
                        ? const Color(0xFF018845)
                        : const Color(
                            0xFFD6EADC), // Change color when selected
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      category,
                      style: TextStyle(
                          color: selectedCategory == category
                              ? const Color(0xFFFFFFFF)
                              : const Color(0xFF018845)),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
    },
  );
}
}



