//
//  NewCustomerViewController.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/27/23.
//

import UIKit

class NewCustomerViewController: UIViewController {
    
    @IBOutlet var createButton: UIButton!
    @IBAction func onCloseButtonTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet var addressTableView: UITableView!
    @IBOutlet var nameTF: UITextField!
    
    @IBOutlet var addressTF: UITextField!

    @IBOutlet var emailTF: UITextField!
    
    var currentAddresses:[Address] = []
    var customerData:CustomerModel?
    var updateCustomerList:(()async -> Void)!
    
    @IBAction func onAddAddress(_ sender: Any) {
        if(!(addressTF.text!.isEmpty)){
            var customerID = 0
            
            if(customerData != nil ){
                customerID = customerData!.id //In case of editing
            }
            let newAddress = Address(id: 0, customerId: customerID, address: addressTF.text!)
            currentAddresses.append(newAddress)
            addressTF.text = ""
            self.addressTableView.reloadData()
            return
        }
  
        AlertHelper.showLoaf(message: "Ingrese una Direcciòn", state: .error,location: .top)
            return
    }
    @IBAction func onCreateButtonTap(_ sender: Any) {
        Task { @MainActor in
            //Validations
            if(self.nameTF.text!.isEmpty){
                AlertHelper.showLoaf(message: "Ingrese el Nombre", state: .error,location: .bottom)
                return
            }
            if(self.emailTF.text!.isEmpty){
                AlertHelper.showLoaf(message: "Ingrese el Email", state: .error,location: .bottom)
                return
            }
            if(self.currentAddresses.count == 0){
                AlertHelper.showLoaf(message: "Agregue una Direcciòn", state: .error,location: .bottom)
                return
            }
            self.showSpinner(onView: self.view)
            //Updating existing customer
            if(self.customerData != nil){
                await updateAddresses()
                await updateCustomer()
            }else{
            //Creating a new Customer
                await createCustomer()
            }
            await self.updateCustomerList()
            self.removeSpinner()
            self.dismiss(animated: true)
        }
    }
    
    func updateCustomer() async{
        let customerVm = CustomerViewModel()
        let customer = CustomerModel(id: self.customerData!.id, name: nameTF!.text!, email: emailTF!.text!, addresses: [])
        _ = await customerVm.updateCustomer(customer:customer )
    }
    
    func updateAddresses() async{
        let addressVm = AddressViewModel()
        
        let addressDictionary = addressListToDictionary(self.currentAddresses)
        for address in self.customerData!.addresses{
            //In case an address was removed
            if(addressDictionary[address.id]==nil){
                _ = await addressVm.removeAddress(id: address.id)
            }
        }
        //In case a new addresss was added
        for address in self.currentAddresses{
            if(address.id == 0){
                _ = await addressVm.addAddress(address: address)
            }
        }
    }
    
    
    func createCustomer()async{
            let customerVm = CustomerViewModel()
            let newCustomer = CustomerModel(id: 0, name: nameTF!.text!, email: emailTF!.text!, addresses: self.currentAddresses)
            _ = await customerVm.createCustomer(customer: newCustomer)
    }
    override func viewDidLoad() {
        
        if let customer = self.customerData{//Editing mode
            self.currentAddresses = customer.addresses
            self.nameTF.text = customer.name
            self.emailTF.text = customer.email
            self.createButton.setTitle("Save", for: .normal)
        }
        createButton.layer.cornerRadius = 8
        self.tableViewSetup()
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
    }
    func tableViewSetup(){
        self.addressTableView.dataSource = self
        self.addressTableView.delegate = self
    }
}

extension NewCustomerViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.currentAddresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currenAddress = self.currentAddresses[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressTableViewCell") as! AddressTableViewCell
        cell.addressTA.text = currenAddress.address
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50   }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            tableView.beginUpdates()
            self.currentAddresses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Quitar"
    }
}
