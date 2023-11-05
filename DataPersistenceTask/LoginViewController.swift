import UIKit

enum KeyChainError: Error {
    case sameItemFound
    case unknown
    case nosuchDataFound
    case KCErrorWithCode(Int)
}

class LoginViewController: UIViewController {
    private let userNameTextField = UITextField()
    private let passwordTextField = UITextField()
    private let logInButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .systemGray3
        
        setUpUserNameTextField()
        setUpPasswordTextField()
        setUpLoginButton()
        setUpSubViews()
        setUpConstrains()
    }
    
    func setUpLoginButton() {
        logInButton.backgroundColor = .systemBlue
        logInButton.setTitle("Log in", for: .normal)
        logInButton.layer.cornerRadius = 12
        
        logInButton.addAction(UIAction(handler: { [weak self] (action: UIAction) in
            let userName = self?.userNameTextField.text
            let password = self?.passwordTextField.text
            
            if userName != "" && password != "" {
                let notesList = NoteListViewController()
                
                if let data = self?.get(service: "login", account: userName!) {
                    let retrievedPassword = String(decoding: data, as: UTF8.self)
                    
                    if retrievedPassword != password! {
                        let alert = UIAlertController(title: "Error", message: "Invalid password", preferredStyle: .actionSheet)
                        alert.addAction(UIAlertAction(title: "Try again", style: UIAlertAction.Style.default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    } else {
                        UserDefaults.standard.setValue(false, forKey: "isFirstTimeLogin")
                        self?.navigationController?.pushViewController(notesList, animated: true)
                    }
                } else {
                    do {
                        try self?.save(
                            service: "login",
                            account: userName!,
                            password: password!.data(using: .utf8) ?? Data()
                        )
                        
                        UserDefaults.standard.setValue(true, forKey: "isFirstTimeLogin")
                        self?.navigationController?.pushViewController(notesList, animated: true)
                    } catch {
                        print(error)
                    }
                }
            }
        }), for: .touchUpInside)
    }
    
    func setUpUserNameTextField() {
        userNameTextField.placeholder = "User name"
        userNameTextField.borderStyle = .roundedRect

    }
    
    func setUpPasswordTextField() {
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
    }
    
    func setUpConstrains() {
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userNameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            userNameTextField.heightAnchor.constraint(equalToConstant: 50),
            userNameTextField.widthAnchor.constraint(equalToConstant: 300),
            
            passwordTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 30),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.widthAnchor.constraint(equalToConstant: 300),
            
            logInButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.widthAnchor.constraint(equalToConstant: 300),
            
        ])
    }
    
    func setUpSubViews() {
        view.addSubview(userNameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(logInButton)
    }
    
    func save(service: String, account: String, password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeyChainError.sameItemFound
        }
        
        guard status == errSecSuccess else {
            throw KeyChainError.unknown
        }
    }
    
    func get(service: String, account: String) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue as AnyObject,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        
        SecItemCopyMatching(query as CFDictionary, &result)

        return result as? Data
    }
}
