//
//  ViewController.swift
//  ios_test_app
//
//  Created by AveNocturna on 2/27/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    var costumerList:[CustomerModel] = []
    var filteredCostumerList:[CustomerModel] = []
    @IBOutlet var costumerTableView: UITableView!
    
    @IBOutlet var searchTF: UITextField!
    func getCostumers() async{
        self.showSpinner(onView: self.view)
        let costomerVm = CustomerViewModel()
        
        let costumers = await costomerVm.getCustomers()
       
        
        if(costumers != nil){
            self.costumerList = costumers!
            self.filteredCostumerList = costumerList
        }
        costumerTableView.reloadData()
        self.removeSpinner()
    }
    @IBAction func onCreateButtonTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewCustomerViewController") as! NewCustomerViewController
        vc.updateCustomerList = {
            await self.getCostumers()
        }
        present(vc,animated: true)
    }
    override func viewDidLoad() {
        searchTF.delegate  = self
        self.hideKeyboardWhenTappedAround()
        tableViewSetup()
        Task.detached{
            await self.getCostumers()
        }
        
        super.viewDidLoad()
    }
    
    
    func tableViewSetup(){
        self.costumerTableView.delegate = self
        self.costumerTableView.dataSource = self
    }
}


extension HomeViewController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCostumerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentCostumer = self.filteredCostumerList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CostumerTableViewCell") as! CustomerTableViewCell
        cell.customer = currentCostumer
        cell.lblName.text = currentCostumer.name
        cell.lblEmail.text = currentCostumer.email
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        filteredCostumerList = costumerList.filter { $0.name.lowercased().contains(searchText.lowercased()) }
            if(searchText.count == 0){
                filteredCostumerList = costumerList
            }
            costumerTableView.reloadData()
            return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        let cell = tableView.cellForRow(at: indexPath) as! CustomerTableViewCell
        let customerData = cell.customer
        let vc = storyboard?.instantiateViewController(withIdentifier: "NewCustomerViewController")as! NewCustomerViewController
        vc.customerData = customerData
        vc.updateCustomerList = {
            await self.getCostumers()
        }
        present(vc,animated: true)
        
    }
}

