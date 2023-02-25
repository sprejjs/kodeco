//
//  ViewController.swift
//  First Core Data App
//
//  Created by Allan Spreys on 25/2/2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  private var people: [NSManagedObject] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    fetchPeopleFromDatabase()
  }

  private func setupView() {
    title = "The List"
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
  }

  @IBAction func addName() {
    let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
    alert.addTextField()

    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] _ in
      guard let textField = alert.textFields?.first, let nameToSave = textField.text else { return }
      saveNewName(nameToSave)
      self.tableView.reloadData()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }

  private func fetchPeopleFromDatabase() {
    // This is the simplest version of the fetch request, it fetches all objects
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")

    do {
      // Here we execute the fetch request
      people = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
  }
  
  private func saveNewName(_ name: String) {
    // Here we are creating a new entity matching the name specified in the data model
    guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext) else { return }
    // Here we create a new managed object and insert it into the managed context
    let person = NSManagedObject(entity: entity, insertInto: managedContext)
    // We can create multiple managed objects from the same entity
    let person2 = NSManagedObject(entity: entity, insertInto: managedContext)

    // Setting value with KVC
    person.setValue(name, forKeyPath: "name")
    person2.setValue("\(name) 2", forKey: "name")

    // Saving the context saved all of the objects in the graph
    appDelegate.saveContext()
    people.append(person)
  }

  private lazy var appDelegate: AppDelegate = {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Unable to get app delegate")
    }
    return appDelegate
  }()

  private lazy var managedContext: NSManagedObjectContext = {
    appDelegate.persistentContainer.viewContext
  }()
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    people.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier) else {
      fatalError("Unable to dequeue a cell")
    }

    let person = people[indexPath.row]
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String

    return cell
  }
}
