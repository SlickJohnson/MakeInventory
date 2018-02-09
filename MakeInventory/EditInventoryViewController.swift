//
//  EditInventoryViewController.swift
//  MakeInventory
//
//  Created by Willie Johnson on 2/7/18.
//  Copyright © 2018 Eliel Gordon. All rights reserved.
//

import UIKit

class EditInventoryViewController: UIViewController {
  let coreDataStack = CoreDataStack.instance

  @IBOutlet weak var inventoryNameField: UITextField!
  @IBOutlet weak var inventoryQuantityField: UITextField!

  var inventory: Inventory!

  override func viewDidLoad() {
    super.viewDidLoad()

    inventoryNameField.text = "\(inventory.name!)"
    inventoryQuantityField.text = "\(inventory.quantity)"
  }

  @IBAction func savePressed(_ sender: Any) {
    guard let name = inventoryNameField.text, let quantity = Int64(inventoryQuantityField.text!) else {return}

    inventory.name = name
    inventory.quantity = quantity

    coreDataStack.save(to: coreDataStack.privateContext)

    self.navigationController?.popViewController(animated: true)
  }
}
