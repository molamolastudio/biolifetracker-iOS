//
//  SuperController.swift
//  BioLifeTracker
//
//  Created by Michelle Tan on 31/3/15.
//  Copyright (c) 2015 Mola Mola Studios. All rights reserved.
//
//  This class controls all controllers of the application, and
//  swaps the presented view controller if needed.
//

import UIKit

class SuperController: UIViewController, UISplitViewControllerDelegate, MenuViewDelegate, CustomPickerPopupDelegate {
    
    let splitVC = UISplitViewController()
    let menu = MenuViewController(style: UITableViewStyle.Grouped)
    let newProject = FormViewController(style: UITableViewStyle.Grouped)
    let newIndividual = FormViewController(style: UITableViewStyle.Grouped)
    
    let ethogramPickerValues = ["Ethogram 1", "Ethogram 2"]
    
    let popup = CustomPickerPopup()
    
    override func viewDidLoad() {
        
        setupMenu()
        setupNewProject()
        
        let data = FormFieldData(sections: 3)
        
        data.setSectionTitle(0, title: "Text Cells")
        data.setSectionTitle(1, title: "Boolean Cells")
        data.setSectionTitle(2, title: "Picker Cells")
        
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addTextCell(section: 0, label: "Notes", hasSingleLine: false, value: "I have no notes.")
        
        data.addBooleanCell(section: 1, label: "Human?")
        data.addButtonCell(section: 1, label: "Button", buttonTitle: "Press", target: self, action: "showPicker", popup: popup)
        
        data.addDatePickerCell(section: 2, label: "Birthdate")
        data.addPickerCell(section: 2, label: "Options", pickerValues: ["Good", "Neutral", "Evil"], isCustomPicker: false)
        
        let controller = FormViewController(style: UITableViewStyle.Grouped)
        controller.setFormData(data)
        controller.cellHorizontalPadding = 10
        controller.roundedCells = true
        
        let masterNav = UINavigationController(rootViewController: menu)
        let detailNav = UINavigationController(rootViewController: controller)
        
        splitVC.viewControllers = [masterNav, detailNav]
        splitVC.delegate = self
        
        self.view.addSubview(splitVC.view)
        splitVC.view.frame = self.view.frame
    }
    
    func showPicker() {
        popup.pickerDelegate = self
        
        popup.data = ethogramPickerValues
        
        self.view.addSubview(popup.view)
        popup.view.frame = self.view.frame
    }
    
    func pickerDidDismiss(selectedIndex: Int?) {
        popup.view.removeFromSuperview()
    }
    
    func setupMenu() {
        menu.title = "BioLifeTracker"
        menu.delegate = self
    }
    
    func setupNewProject() {
        newProject.title = "New Project"
        newProject.setFormData(getFormDataForNewProject())
        newProject.cellHorizontalPadding = 10
        newProject.roundedCells = true
    }
    
    func setupNewIndividual() {
        newIndividual.title = "New Individual"
        newIndividual.setFormData(getFormDataForNewIndividual())
        newIndividual.cellHorizontalPadding = 10
        newIndividual.roundedCells = true
    }
    
    func getFormDataForNewProject() -> FormFieldData {
        let data = FormFieldData(sections: 2)
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addPickerCell(section: 0, label: "Ethogram", pickerValues: ethogramPickerValues, isCustomPicker: false)
        data.setSectionTitle(1, title: "Members")
        data.addTextCell(section: 1, label: "Enter Member Here", hasSingleLine: true) // To be decided
        return data
    }
    
    func getFormDataForNewIndividual() -> FormFieldData {
        let data = FormFieldData(sections: 1)
        data.addTextCell(section: 0, label: "Name", hasSingleLine: true)
        data.addTextCell(section: 0, label: "Tags", hasSingleLine: false)
        data.addTextCell(section: 1, label: "Photos", hasSingleLine: true) // Photo picker cell
        return data
    }
    
    func userDidSelectProjects() {
        println("projects")
        let data = newProject.getFormData()
        let name = data[0] as String
        let ethogram = Ethogram(name: data[1] as String)
        let project = Project(name: name, ethogram: ethogram)
    }
    
    func userDidSelectEthograms() {
        
    }
    
    func userDidSelectGraphs() {
        
    }
    
    func userDidSelectData() {
        
    }
    
    func userDidSelectSettings() {
        
    }
    
    func userDidSelectFacebookLogin() {
        
    }
    
    func userDidSelectGoogleLogin() {
        
    }
    
    func userDidSelectLogout() {
        
    }
    
    func userDidSelectSessions(project: Project) {
        
    }
    
    func userDidSelectIndividuals(project: Project) {
        
    }
    
    func userDidSelectObservations(project: Project, session: Session) {
        
    }
}
