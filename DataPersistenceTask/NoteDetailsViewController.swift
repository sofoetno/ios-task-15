import UIKit

class NoteDetailsViewController: UIViewController {
    var note: Note? = nil
    var noteIndex: Int? = nil
    let editButton = UIButton()
    let deleteButton = UIButton()
    let singleNoteTitle = UILabel()
    let singleDesription = UILabel()
    var noteListViewController: NoteListViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setUpSubViews()
        setUpDeleteButton()
        setUpEditButton()
        setUpConstrains()
        refreshNote()
    }
    
    func setUpSubViews() {
        view.addSubview(editButton)
        view.addSubview(deleteButton)
        view.addSubview(singleDesription)
        view.addSubview(singleNoteTitle)
    }
    
    func setUpDeleteButton() {
        deleteButton.backgroundColor = .red
        deleteButton.layer.cornerRadius = 8
        deleteButton.setTitle("Delete", for: .normal)
        
        deleteButton.addAction(UIAction(handler: { [weak self] (action: UIAction) in
            if let index = self?.noteIndex {
                self?.noteListViewController?.removeNote(index: index)
                self?.navigationController?.popViewController(animated: true)
            }
        }), for: .touchUpInside)
    }
    
    func setUpEditButton() {
        editButton.backgroundColor = .blue
        editButton.layer.cornerRadius = 8
        editButton.setTitle("Edit", for: .normal)
        
        editButton.addAction(UIAction(handler: { [weak self] (action: UIAction) in
            let editPage = AddNoteViewController()
            editPage.noteListViewContoller = self?.noteListViewController
            editPage.noteDetailsViewController = self
            editPage.noteIndex = self?.noteIndex
            editPage.note = self?.note
            self?.present(editPage, animated: true)
        }), for: .touchUpInside)
    }
    
    func refreshNote() {
        note = noteListViewController?.getNote(index: noteIndex ?? 0)
        
        singleNoteTitle.text = note?.title
        singleDesription.text = note?.description
    }
    
    func setUpConstrains() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        singleNoteTitle.translatesAutoresizingMaskIntoConstraints = false
        singleDesription.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            editButton.heightAnchor.constraint(equalToConstant: 50),
            editButton.widthAnchor.constraint(equalToConstant: 100),
            
            deleteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.widthAnchor.constraint(equalToConstant: 100),
            
            singleNoteTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            singleNoteTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            singleNoteTitle.heightAnchor.constraint(equalToConstant: 100),
            singleNoteTitle.widthAnchor.constraint(equalToConstant: 300),
            
            singleDesription.topAnchor.constraint(equalTo: singleNoteTitle.bottomAnchor, constant: 20),
            singleDesription.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            singleDesription.heightAnchor.constraint(equalToConstant: 100),
            singleDesription.widthAnchor.constraint(equalToConstant: 300),
        ])
    }
}
