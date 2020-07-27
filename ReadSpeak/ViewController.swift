//
//  ViewController.swift
//  ReadSpeak
//
//  Created by Pranav Ramesh on 7/8/20.
//

import UIKit
import AVFoundation

var accentIndex = 31

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        toolbar.tintColor = UIColor(named: "AccentColor")
        
        toolbar.items = [
            UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearAction)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        ]
        toolbar.sizeToFit()
        
        self.textView.inputAccessoryView = toolbar
    }
    
    @objc func doneAction() {
        self.textView.resignFirstResponder()
    }
    
    @objc func clearAction() {
        self.textView.text = ""
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccentCell", for: indexPath)
        cell.textLabel?.text = voiceName[accentIndex]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showAccentPicker", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in backViews {
            i.layer.cornerRadius = 10
            i.layer.shadowColor = UIColor.black.cgColor
            i.layer.shadowOffset = CGSize(width: 0, height: 10)
            i.layer.shadowOpacity = 0.25
            i.layer.shadowRadius = 10
            i.layer.shadowPath = UIBezierPath(rect: i.bounds).cgPath
        }
        
        playButton.layer.cornerRadius = 10
        playButton.layer.shadowColor = UIColor.black.cgColor
        playButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        playButton.layer.shadowOpacity = 0.25
        playButton.layer.shadowRadius = 10
        playButton.layer.shadowPath = UIBezierPath(rect: playButton.bounds).cgPath
        
        stopButton.layer.cornerRadius = 10
        stopButton.layer.shadowColor = UIColor.black.cgColor
        stopButton.layer.shadowOffset = CGSize(width: 0, height: 10)
        stopButton.layer.shadowOpacity = 0.25
        stopButton.layer.shadowRadius = 10
        stopButton.layer.shadowPath = UIBezierPath(rect: stopButton.bounds).cgPath
        
        addDoneButtonOnKeyboard()
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backViews: [UIView]!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var speaker = AVSpeechSynthesizer()
    
    @IBAction func play(_ sender: UIButton) {
        let utterance = AVSpeechUtterance(string: textView.text)
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: voiceISO[accentIndex])
        speaker.speak(utterance)
    }
    
    @IBAction func stop(_ sender: UIButton) {
        speaker.stopSpeaking(at: .word)
    }
    
}

class AccentPickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return voiceName.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return voiceName[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedIndex = row
    }
    
    var selectedIndex = accentIndex
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.selectRow(accentIndex, inComponent: 0, animated: false)
    }
    @IBOutlet weak var pickerView: UIPickerView!
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        accentIndex = selectedIndex
        self.performSegue(withIdentifier: "modifyAccent", sender: nil)
    }
}
