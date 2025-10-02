//
//  ContentView.swift
//  MobileDev_Lab2_nashagober
//
//  Created by nash gober on 9/18/25.
// Implements a simple library book lending app, where all books
// manually added will have cusomtized images, and any books added
// by the user will have a filler book image
//

import SwiftUI
internal import Combine

//Intro Page: Allows to select add a book or view books


// Main Page, allows you to choose between viewing the book list, and
// adding new books
struct ContentView: View {
    var body: some View {
        // Begin a navigation stack to allow for button redirection
        NavigationStack {
                
            // Vertical stack containing buttons
            VStack {
                
                Spacer()
                
                // Button to navigate to the book list view
                NavigationLink {
                    BookListView()
                } label: {
                    Text("Book List")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                
                // Button to navigate to book addition page
                NavigationLink {
                    AdditionFormView()
                } label: {
                    Text("Add Book")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
                
                Spacer()
                
            }
        }
    }
}


// Structure for a book that contains name, author, unique id, borrowed value, image name, and added boolean to determine pre or post added books
struct Book: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let author: String
    var borrowed: Bool
    let imageName: String
    var added: Bool
    
}

// Book list class to which contains a modifiable array to store books
// Can be modified from within different views
class BookList: ObservableObject {
    
    static var shared = BookList()
    
    
    @Published var books: [Book] = [
    
        Book(name: "1984", author: "George Orwell", borrowed: false, imageName: "1984", added: false),
        Book(name: "All Quiet on the Western Front", author: "Erich Maria Remarque", borrowed: false, imageName: "All Quiet on the Western Front", added: false),
        Book(name: "The Great Gatsby", author: "F. Scott Fitzgerald", borrowed: false, imageName: "The Great Gatsby", added: false),
        Book(name: "The Hobbit", author: "F. Scott Fitzgerald", borrowed: false, imageName: "The Hobbit", added: false),
        Book(name: "To Kill A Mockingbird", author: "Harper Lee", borrowed: false, imageName: "To Kill A Mockingbird", added: false)
    
    ]
}

//Book List view, showcases all available books and allows users to
// check them out while displaying availability
struct BookListView: View {
    
    @ObservedObject var bookList = BookList.shared

    
    var body: some View {
        
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        //Create a scrolling view
        ScrollView {
            //Create a lazy grid view to display two books side by side
            //in each row
            LazyVGrid(columns: columns) {
                //Loop through all books and display their info and buttons
                ForEach(bookList.books.indices, id: \.self) { index in
                    let book = bookList.books[index]
                    VStack{
                        Image(book.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        Text(book.name)
                            .bold()
                            .font(.system(size: 20))
                        
                        Text(book.author)
                        
                        Button(action: {
                            bookList.books[index].borrowed.toggle()
                        }) {
                            Text(book.borrowed ? "Return" : "Borrow")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(book.borrowed ? Color.red : Color.green)
                                .cornerRadius(10)
                        }
                        
                    }
                    .padding()
                    .cornerRadius(10)
                    }
                }
                .padding()
            }
            
        
    }
}

// Addition Form view
struct AdditionFormView: View {
    
    //Create variables to store entered field values
    @State var InputName: String = ""
    @State var InputAuthor: String = ""
    @State var InputImageName: String = ""
    
    
    var body: some View {
        
        // Vertical Stack
        VStack{
            
            
            Text("ADD BOOK")
                .bold()
                .font(.title)
            
            // Book name field
            TextField("Book Name", text: $InputName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
            // Book Author field
            TextField("Book Author", text: $InputAuthor)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            // Add button, which creates a new book using the values in the fields above
            Button(action: {
                
                let newbook = Book(name: InputName, author: InputAuthor, borrowed: false, imageName: "book", added: true)
                BookList.shared.books.append(newbook)
                
                InputName = ""
                InputAuthor = ""
                
                
            }) {
                Text("Add New Book")
            }
            
        }
        
    }
}

#Preview {
    ContentView()
}
