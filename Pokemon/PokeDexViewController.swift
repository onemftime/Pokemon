//
//  PokeDexViewController.swift
//  Pokemon
//
//  Created by Apple on 7/22/17.
//  Copyright © 2017 Jeremy. All rights reserved.
//

import UIKit

class PokeDexViewController: UIViewController{

    var caughtPokemons : [Pokemon] = []
    var uncaughtPokemons : [Pokemon] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        caughtPokemons = getAllCaughtPokemons()
        uncaughtPokemons = getAllUncaughtPokemons()

    }
  
    
    

    @IBAction func mapTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
