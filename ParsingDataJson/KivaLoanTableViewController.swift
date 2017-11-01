//
//  KivaLoanTableViewController.swift
//  ParsingDataJson
//
//  Created by Macbook pro on 01/11/17.
//  Copyright © 2017 Shin Corp. All rights reserved.
//

import UIKit

class KivaLoanTableViewController: UITableViewController {
    // deklarasi url u/ mengambil data jaom
    let KivaLoanURL = "http://api.kivaws.org/v1/loans/newest.json"
    //deklarasi variable loans untuk memanggil class loan yg sudah d buat sebelumnya
    var loans = [Loan]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // mengambil data dari api lian
        getLatestLoans()
        
        //self sizing cell
        //mengatur tinggi row table menjadi 92
        tableView.estimatedRowHeight = 92.0
        //mengatur tinnggi row table menjadi dimensi otomatis
        tableView.rowHeight = UITableViewAutomaticDimension

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return loans.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KivaLoanTableViewCell

        // Configure the cell...
        //memasukkan nilai ke dalam masing 2 lanel
        cell.nameLabel.text = loans[indexPath.row].name
        cell.countryLabel.text = loans[indexPath.row].country
        cell.useLabel.text = loans[indexPath.row].use
        cell.amountLabel.text = "S\(loans[indexPath.row].amount)"

        return cell
    }
    
    //mark:- json parsing
    //membuat method baru dg nama : getLatestLoans()
    func getLatestLoans() {
        //deklarasi loanURL untuk memanggil variable kivaloansURL yg tleah d deklarasi sbulmnya
        guard let loanUrl = URL(string: KivaLoanURL) else {
            return //return berfingsi untuk mengembalikan nilai yg di daoat ketika memanggil variable loan url
        }
        
        // deklarasi request ubntuk url loan url \
        let request = URLRequest(url: loanUrl)
        //deklarsi task untuk mengambil data dari varian]ble request di atas
        let task = URLSession.shared.dataTask(with: request,completionHandler: { (data, response, error) -> Void in
            
            // mengecek  apakah ada eror apa tidak
            if let error = error {
                //kondisi ketika ada eror
                // mencetak eror
                print(error)
                return//mengembalikan nilai eror yg di dapat
            }
            
            // parse json data
            // deklarasi variable data untukmemanggil data
            if let data = data {
                // pada bagian ini akan memanggil method parseJsonData yg akan kita buat d bawah
                self.loans = self.parseJsonData(data: data)
                
                // reload table view
                OperationQueue.main.addOperation ({
                    // reload kembali data
                    self.tableView.reloadData()
            
                })
            }
        })
        //task akan melakukan resume untuk memanggil data jso nya
        task.resume()
    }
    // memmbuat method baru dg nama parse json data
    // method ini akan melakukan parsing data json
    func parseJsonData(data: Data) -> [Loan] {
        //deklarasi variable loans sbg object dari class loan
        var loans = [Loan]()
        // akan melakukan parulangan thd data json yg di parsing
        do {
            
            // deklarasi json result untuk mengambl data dari json nua
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
        
            // parse json datas
            // deklarasi json loans unti]uk memanggil data array jsonresult yg bernama loan
            let jsonLoans = jsonResult?["loans"] as! [AnyObject]
            // akan melakukan pemanggilan data berulanh2 selama json loan memiliki data json atray yg dari variable json laoan
            for jsonLoan in jsonLoans {
                // deklarasi loan sbg objec dari class loan
                let loan = Loan()
                // memasukkan nilaidalam masing2 object class loan
                //memasukkan nilai dg nama bjec name sbg string
                loan.name = jsonLoan["name"] as! String
                //memasukkan nilai jsonLoan dg nama objc amouhnt sbg integer
                loan.amount = jsonLoan["loan_amount"] as! Int
                //memasukkan nilai jsonLoan dg nama objc use sbg String
                loan.use = jsonLoan["use"] as! String
                ////memasukkan nilai jsonLoan dg nama objc location sbg String
                let location = jsonLoan["location"] as! [String:AnyObject]
                // memasukkan nilai jsonloan dg nama obect country sbg string
                loan.country = location["country"] as! String
                //proses memasukkan data ke dalam object
                loans.append(loan)
                
             }
        } catch {
            print(error)
        }
        return loans
    }

}
