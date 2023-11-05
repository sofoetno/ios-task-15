import UIKit

class NoteListViewController: UIViewController {
    private var notes: [Note] = []
    
    private var loginViewController: LoginViewController?
    private let addButton = UIButton()
    private let tableList = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        
        checkIfFirstTimeLogin()
        setupTableList()
        setupaddButton()
        addSubviews()
        setupConstrains()
    }
    
    func checkIfFirstTimeLogin() {
        let isFirstTimeLogin = UserDefaults.standard.bool(forKey: "isFirstTimeLogin")
        if isFirstTimeLogin == true {
            let alert = UIAlertController(title: "Welcome!", message: "Hello, welcome to this amazing app!", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func setupTableList() {
        tableList.backgroundColor = .systemGray3
        tableList.register(NotesCell.self, forCellReuseIdentifier: "Cell")
        tableList.dataSource = self
        tableList.delegate = self
    }
    
    func setupaddButton() {
        addButton.backgroundColor = .systemRed
        addButton.setTitle("Add note", for: .normal)
        addButton.layer.cornerRadius = 8
        addButton.addAction(UIAction(handler: { action in
            let newItemController = AddNoteViewController()
            newItemController.noteListViewContoller = self
            self.present(newItemController, animated: true)
        }), for: .touchUpInside)
    }
    
    func addSubviews() {
        view.addSubview(addButton)
        view.addSubview(tableList)
    }
    
    func setupConstrains() {
        tableList.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableList.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 15),
            tableList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            tableList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            tableList.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButton.widthAnchor.constraint(equalToConstant: 150)
        
            
        ])
    }
    
    func getNote(index: Int) -> Note {
        return notes[index]
    }
    
    func addNote(note: Note) {
        notes.append(note)
        tableList.reloadData()
    }
    
    func removeNote(index: Int) {
        notes.remove(at: index)
        tableList.reloadData()
    }
    
    func editNote(note: Note, index: Int) {
        notes[index] = note
        tableList.reloadData()
    }
}

extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NotesCell
        cell?.configure(note: notes[indexPath.row])
        return cell ?? UITableViewCell()
    }
}

extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailsViewController =  NoteDetailsViewController()
        
        noteDetailsViewController.noteListViewController = self
        noteDetailsViewController.noteIndex = indexPath.row
        
        navigationController?.pushViewController(noteDetailsViewController, animated: true)
    }
}

