//
//  ViewController.swift
//  First Core Data App
//
//  Created by Allan Spreys on 25/2/2023.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  var names: [String] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
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
      self.names.append(nameToSave)
      self.tableView.reloadData()
    }

    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

    alert.addAction(saveAction)
    alert.addAction(cancelAction)

    present(alert, animated: true)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    names.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier) else {
      fatalError("Unable to dequeue a cell")
    }

    cell.textLabel?.text = names[indexPath.row]

    return cell
  }
}
