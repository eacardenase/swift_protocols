import Cocoa

protocol TabularDataSource {
    var numberOfRows: Int { get }
    var numberOfColumns: Int { get }
    
    func label(forColumn column: Int) -> String
    func itemFor(row: Int, column: Int) -> String
}

func printTable(_ dataSource: TabularDataSource & CustomStringConvertible) {
    print("Table: \(dataSource)")
    
    var columnWidths = [Int]()
    var tableContent: [[String]] = []
    var headerContent = [String]()
    
    for columnIndex in 0..<dataSource.numberOfColumns {
        let label = dataSource.label(forColumn: columnIndex)
        
        columnWidths.append(label.count)
        headerContent.append(label)
    }
    
    for rowIndex in 0..<dataSource.numberOfRows {
        var rowContent = [String]()
        
        for columnIndex in 0..<dataSource.numberOfColumns {
            let item = dataSource.itemFor(row: rowIndex, column: columnIndex)
            
            if item.count > columnWidths[columnIndex] {
                columnWidths[columnIndex] = item.count
            }
            
            rowContent.append(item)
        }
        
        tableContent.append(rowContent)
    }
    
    var headerContentFormatted = headerContent.enumerated().map {
        let count = $1.count - columnWidths[$0]
        let padding = repeatElement(" ", count: abs(count)).joined()
        
        return $1 + padding
    }.joined(separator: " | ")
    
    headerContentFormatted = "| \(headerContentFormatted) |"
    
    var sectionSeparator = repeatElement("-", count: headerContentFormatted.count - 2).joined()
    sectionSeparator = "+\(sectionSeparator)+"
    
    let tableContentFormatted = tableContent.map { row in
        let mainContent = row.enumerated().map {
            let count = $1.count - columnWidths[$0]
            let padding = repeatElement(" ", count: abs(count)).joined()
            
            return $1 + padding
        }.joined(separator: " | ")
        
        return "| " + mainContent + " |"
    }.joined(separator: "\n")
    
    print(sectionSeparator)
    print(headerContentFormatted)
    print(sectionSeparator)
    print(tableContentFormatted)
    print(sectionSeparator)
}

struct Person {
    let name: String
    let age: Int
    let yearsOfExperience: Int
}

struct Department: TabularDataSource, CustomStringConvertible {
    let name: String
    var people = [Person]()
    
    var description: String {
        return "Department (\(name))"
    }
    
    mutating func add(_ person: Person) {
        people.append(person)
    }
    
    var numberOfRows: Int {
        return people.count
    }
    
    var numberOfColumns: Int {
        return 3
    }
    
    func label(forColumn column: Int) -> String {
        switch column {
        case 0: return "Employee Name"
        case 1: return "Age"
        case 2: return "Years of Experience"
        default: fatalError("Invalid column!")
        }
    }
    
    func itemFor(row: Int, column: Int) -> String {
        let person = people[row]
        
        switch column {
        case 0: return person.name
        case 1: return String(person.age)
        case 2: return String(person.yearsOfExperience)
        default: fatalError("Invalid column!")
        }
    }
}

var department = Department(name: "Engineering")

department.add(Person(name: "Eva", age: 3000, yearsOfExperience: 6))
department.add(Person(name: "Saleh", age: 40, yearsOfExperience: 18))
department.add(Person(name: "Amit", age: 50000, yearsOfExperience: 20))
department.add(Person(name: "Edwin", age: 29, yearsOfExperience: 3))

printTable(department)

let operationsDataSource: TabularDataSource = Department(name: "Operations") // protocols as types
let engineeringDataSource = department as TabularDataSource // using protocols for type casting

let unsafeCast = operationsDataSource as? Department // unsafe because not every TabularDataSource would be a Department

let mikey = Person(name: "Mikey", age: 37, yearsOfExperience: 10)

mikey is TabularDataSource // mikey does not conform to TabularDataSource protocol
department is TabularDataSource // department conforms to TabularDataSource


struct Book {
    let title: String
    let authors: String
    let averageReview: Double
}

struct BookCollection: TabularDataSource, CustomStringConvertible {
    let name: String
    var collection = [Book]()
    
    var description: String {
        "Collection \(name)"
    }
    
    mutating func add(_ book: Book) {
        collection.append(book)
    }
    
    var numberOfRows: Int {
        collection.count
    }
    
    var numberOfColumns: Int {
        3
    }
    
    func label(forColumn column: Int) -> String {
        switch column {
        case 0: return "Book Title"
        case 1: return "Authors"
        case 2: return "Review Avg."
        default: fatalError("Invalid column!")
        }
    }
    
    func itemFor(row: Int, column: Int) -> String {
        let book = collection[row]
        
        switch column {
        case 0: return book.title
        case 1: return book.authors
        case 2: return String(book.averageReview)
        default: fatalError("Invalid column!")
        }
    }
}

var myFavorites = BookCollection(name: "My Favorites")

myFavorites.add(Book(title: "Project Hail Mary", authors: "Andy Weir", averageReview: 5))
myFavorites.add(Book(title: "So Good They Can't Ignore You", authors: "Cal Newport", averageReview: 5))
myFavorites.add(Book(title: "Mistborn: The Final Empire", authors: "Brandon Sanderson", averageReview: 5))

printTable(myFavorites)
