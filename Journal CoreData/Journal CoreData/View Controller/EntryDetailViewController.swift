//
//  EntryDetailViewController.swift
//  Journal CoreData
//
//  Created by Iyin Raphael on 9/24/18.
//  Copyright © 2018 Iyin Raphael. All rights reserved.
//

import UIKit
import CoreData


class EntryDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews(){
        if isViewLoaded {
            title =  entry?.title
            titleTextField.text = entry?.title
            textView.text = entry?.bodyText

            let mood = entry?.moodType ?? .normal
            let moodIndex = MoodType.allCases.index(of: mood)!
            segmentedControl.selectedSegmentIndex = moodIndex
            
        }
    }
    
    var entry: Entry?{
        didSet{
            updateViews()
        }
    }
    
    @IBAction func save(_ sender: Any) {
        guard let title = titleTextField.text,
        let bodyText = textView.text else {return}
        let indexSegment = segmentedControl.selectedSegmentIndex
        let mood = MoodType.allCases[indexSegment].rawValue

        if let entry = entry{
            entryController.update(entry: entry, title: title, bodytext: bodyText, mood: mood)
        }else{
            let entry = Entry(title: title, bodyText: bodyText, mood: MoodType(rawValue: mood)!)
            entryController.put(entry: entry)
            entryController.saveToPersistence()
         }

       navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    let entryController = EntryController()
    
}
