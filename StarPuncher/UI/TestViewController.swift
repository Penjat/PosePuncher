import UIKit

class TestViewController: UIViewController {
    let number: Int
    init(number: Int) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        print("View loaded\(view.bounds)")
        view.backgroundColor = .red
        let label = UILabel()
        label.text = "Anjali is Hot🔥"
        label.font = UIFont.systemFont(ofSize: 300)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view appeared \(view.bounds)")
    }
}
