//
//  ViewController.swift
//  MakeInventory
//
//  Created by Eliel A. Gordon on 11/12/17.
//  Copyright © 2017 Eliel Gordon. All rights reserved.
//

import UIKit
import CoreData

class InventoriesViewController: UIViewController {
  let stack = CoreDataStack.instance
  var selectedInventory: Inventory! = nil

  @IBOutlet weak var tableView: UITableView!
  var inventories = [Inventory]()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let fetch = NSFetchRequest<Inventory>(entityName: "Inventory")
    do {
      let result = try stack.viewContext.fetch(fetch)
      self.inventories = result
      self.tableView.reloadData()

    } catch let error {
      print(error)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let editScreen = segue.destination as? EditInventoryViewController
    editScreen?.inventory = selectedInventory
  }
}


extension InventoriesViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return inventories.count
  }
}

extension InventoriesViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath)

    let item = inventories[indexPath.row]

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy MMM dd"
    cell.textLabel?.text = "\(dateFormatter.string(from: item.dateEntered!)): \(item.name!)"
    cell.detailTextLabel?.text = "x\(item.quantity)"

    return cell
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    let item = inventories[indexPath.row]
    let context = stack.privateContext
    let inv = stack.privateContext.object(with: item.objectID) as! Inventory

    let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
      context.delete(inv)

      self.stack.save(to: context)
      self.inventories.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
      self.selectedInventory = item
      self.performSegue(withIdentifier: "edit", sender: nil)
    }

    edit.backgroundColor = .blue

    return [delete, edit]
  }
}
