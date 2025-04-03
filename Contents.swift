import Cocoa

protocol TabularDataSource {
    var numberOfRows: Int { get }
    var numberOfColumns: Int { get }
    
    func label(forColumn column: Int) -> String
    func itemFor(row: Int, column: Int) -> String
}

func printTable(_ dataSource: TabularDataSource & CustomStringConvertible) {
    print("Table: \(dataSource)")
    
    var headerRow = "|"
    var columnWidths = [Int]()
    
    for columnIndex in 0..<dataSource.numberOfColumns {
        let label = dataSource.label(forColumn: columnIndex)
        let columnHeader = " \(label) |"
        
        headerRow += columnHeader
        columnWidths.append(label.count)
    }
    
    let sectionSeparator = repeatElement("-", count: headerRow.count).joined()
    
    print(sectionSeparator)
    print(headerRow)
    print(sectionSeparator)
    
    for rowIndex in 0..<dataSource.numberOfRows {
        var out = "|"
        
        for columnIndex in 0..<dataSource.numberOfColumns {
            let item = dataSource.itemFor(row: rowIndex, column: columnIndex)
            var paddingNedded = columnWidths[columnIndex] - item.count
            
            if paddingNedded < 0 {
                paddingNedded += abs(paddingNedded)
            }
            
            let padding = repeatElement(" ", count: paddingNedded)
                .joined(separator: "")
            
            out += " \(item)\(padding) |"
        }
        
        print(out)
    }
    
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

department.add(Person(name: "Eva", age: 30, yearsOfExperience: 6))
department.add(Person(name: "Saleh", age: 40, yearsOfExperience: 18))
department.add(Person(name: "Amit", age: 5000, yearsOfExperience: 20))
department.add(Person(name: "Edwin", age: 29, yearsOfExperience: 3))

printTable(department)

let operationsDataSource: TabularDataSource = Department(name: "Operations") // protocols as types
let engineeringDataSource = department as TabularDataSource // using protocols for type casting

let unsafeCast = operationsDataSource as? Department // unsafe because not every TabularDataSource would be a Department

let mikey = Person(name: "Mikey", age: 37, yearsOfExperience: 10)

mikey is TabularDataSource // mikey does not conform to TabularDataSource protocol
department is TabularDataSource // department conforms to TabularDataSource


