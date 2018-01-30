//
//  ARDemosViewController.swift
//  ARDemos
//
//  Created by GEORGE QUENTIN on 30/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import ARKit
import AppCore
import ARDrawingDemo
import ARPlanetsDemo
import Chameleon

private let CellIdentifier = "tableCell"

private struct Option {
    let title: String
    let name: String
    let bundle: String
    let storyBoard : String
}

public class ARDemosViewController: UITableViewController {

    private var options: [Option] = []
    let selectedColor : UIColor = .random
    
    func updateNavBar (with color : UIColor) {
        if let navController = navigationController {
            let constrastColor = ContrastColorOf(color, returnFlat: true)
            // items color
            navController.navigationBar.tintColor = constrastColor
            
            // background color
            navController.navigationBar.barTintColor = color
            
            // text color
            navController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: constrastColor]
        }
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ARKit Demos"
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifier)
        self.tableView.separatorStyle = .none
        
        self.options = [
            Option(title:"AR Drawing", 
                   name: "ARDrawingViewController", 
                   bundle:"com.geo-games.ARDrawingDemo", 
                   storyBoard: "ARDrawing"),
            Option(title: "AR Planets", 
                   name: "ARPlanetsViewController", 
                   bundle: "com.geo-games.ARPlanetsDemo", 
                   storyBoard: "ARPlanets")
        ]
        
        updateNavBar(with: selectedColor)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ARConfiguration.isSupported == false {
            let alert = UIAlertController(title: "Device Requirement", 
                                          message: "Sorry, this app only runs on devices that support augmented reality through ARKit.", 
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
 
}



// MARK: - UITableViewDataSource
extension ARDemosViewController {
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.options.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        
        let numberOfTodoItems = self.options.count
        
        cell.backgroundColor =  selectedColor.darken(byPercentage: 
            (CGFloat(indexPath.row) / CGFloat(numberOfTodoItems)) )
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor ?? .white, returnFlat: true)
        
        cell.textLabel?.text = self.options[indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }

    // MARK: - UITableViewDelegate

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let option = options[indexPath.row]
        let bundleIdentifier = option.bundle
        let bundle = Bundle(identifier: bundleIdentifier)
        let storyBoard = option.storyBoard
        let storyboard = UIStoryboard(name: storyBoard, bundle: bundle)       
        let vc = storyboard.instantiateViewController(withIdentifier: option.name)
        vc.title = option.title
        navigationController?.pushViewController(vc, animated: true)
       
    }
}
