import UIKit

class AddNoteViewController: UIViewController {
    private var nameInput = UITextField()
    private var descriptionInput = UITextField()
    private var saveButton = UIButton()
    
    var noteListViewContoller: NoteListViewController?
    var noteDetailsViewController: NoteDetailsViewController?
    var note: Note? = nil
    var noteIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUpNameInput()
        setUpDescriptionInput()
        setUpSaveButton()
        setUpSubViews()
        setUpConstrains()
    }
    
    func setUpNameInput() {
        nameInput.placeholder = "Note name"
        nameInput.text = note?.title
    }
    
    func setUpDescriptionInput() {
        descriptionInput.text = note?.description
        descriptionInput.placeholder = "description"
    }
    
    func setUpSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 8
        saveButton.backgroundColor = .green
        
        saveButton.addAction(UIAction(handler: { [weak self] (action: UIAction) in
            let name = self?.nameInput.text ?? ""
            let description = self?.descriptionInput.text ?? ""
            
            if name != "" && description != "" {
                let noteToSave = Note(title: name, description: description)
                
                if self?.note == nil {
                    self?.noteListViewContoller?.addNote(note: noteToSave)
                } else {
                    self?.noteListViewContoller?.editNote(note: noteToSave, index: self?.noteIndex ?? 0)
                    self?.noteDetailsViewController?.refreshNote()
                }
                self?.dismiss(animated: true)
            }
        }), for: .touchUpInside)
    }
    
    func setUpSubViews() {
        view.addSubview(nameInput)
        view.addSubview(descriptionInput)
        view.addSubview(saveButton)
    }
    
    func setUpConstrains() {
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        nameInput.translatesAutoresizingMaskIntoConstraints = false
        descriptionInput.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 50),
            
            nameInput.topAnchor.constraint(equalTo: saveButton.topAnchor, constant: 300),
            nameInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameInput.heightAnchor.constraint(equalToConstant: 50),
            nameInput.widthAnchor.constraint(equalToConstant: 200),
            
            descriptionInput.topAnchor.constraint(equalTo: nameInput.bottomAnchor, constant: 30),
            descriptionInput.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionInput.heightAnchor.constraint(equalToConstant: 50),
            descriptionInput.widthAnchor.constraint(equalToConstant: 200),
            
        ])
    }
}
