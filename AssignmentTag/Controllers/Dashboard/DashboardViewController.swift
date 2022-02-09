//
//  DashboardViewController.swift
//  AssignmentTag
//
//  Created by Prasanta Santikari on 08/02/22.
//

import UIKit

class DashboardViewController: UIViewController {
    /// IBOutlet used
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerViewBackgroundView: UIView!
    @IBOutlet weak var accountBalance: UILabel!
    @IBOutlet weak var accountNumber: UILabel!
    @IBOutlet weak var accountHolder: UILabel!
    @IBOutlet weak var transferButton: UIButton!
    var transactions: [UserTransaction] = []
    let refreshControl = UIRefreshControl()

    var viewModel = DashboardViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        pullToRefresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBalance()
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    /// TableView refresh
    func pullToRefresh() {
        refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func pullRefresh() {
        refreshControl.endRefreshing()
        self.getBalance()
    }
    
    /// Setup UI
    func setupUI() {
        buttonSetup()
        setUpTableView()
        addLogoutButton()
    }
    
    /// Button Setup
    func buttonSetup() {
        transferButton.configure(30, borderColor: .black)
    }

    /// To Setup TableView
    private func setUpTableView() {
        tableView?.register(UINib(nibName: Constants.dashboardCell,
                                 bundle: nil),
                           forCellReuseIdentifier: Constants.dashboardCell)
        tableView?.layer.masksToBounds = false
        tableView?.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        tableView?.layer.shadowOpacity = 1
        tableView?.layer.shadowRadius = 5
        tableView?.layer.shadowOffset = .init(width: 0, height: 5)
        
        headerViewBackgroundView?.clipsToBounds = true
        headerViewBackgroundView?.layer.cornerRadius = 20
        headerViewBackgroundView?.layer.maskedCorners = [.layerMaxXMinYCorner,
                                                        .layerMaxXMaxYCorner]
        headerViewBackgroundView?.shadow()
    }
    
    private func addLogoutButton() {
        let logoutButton = UIButton(type: .custom)
        logoutButton.setTitle("logout",
                              for: .normal)
        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 20,
                                                          weight: .bold)
        logoutButton.setTitleColor(.black,
                                   for: .normal)
        logoutButton.frame = CGRect(x: 0,
                                    y: 0,
                                    width: 70,
                                    height: 30)
        logoutButton.backgroundColor = .clear
        logoutButton.addTarget(self,
                             action: #selector(logOut(sender:)),
                             for: UIControl.Event.touchUpInside)
        let view = UIView(frame: CGRect(x: 0,
                                        y: 0,
                                        width: 80,
                                        height: 30))
        view.bounds = view.bounds.offsetBy(dx: -5,
                                           dy: 0)
        view.addSubview(logoutButton)
        let backGroudView = UIBarButtonItem(customView: view)
        view.backgroundColor = .clear
        navigationItem.rightBarButtonItem = backGroudView
    }
    
    @objc func logOut(sender : UIButton) {
        Keychain.removeValue(forKey: "userToken")
        navigationController?.popViewController(animated: true)
    }
    
    /// Get Balance Api
    private func getBalance() {
        LoadingView.show()
        viewModel.getBalance { [weak self] (responseModel) in
            guard let self = self else { return }
            LoadingView.hide()
            DispatchQueue.main.async {
                if responseModel?.status == StatusReponse.success {
                    DispatchQueue.main.async {
                        self.accountBalance.text = "\(Constants.currencyType) \((responseModel?.balance ?? 0.0).formattedWithSeparator)"
                        self.accountNumber.text = responseModel?.accountNo ?? ""
                        self.accountHolder.text = UserDefaults.standard.string(forKey: Constants.username)
                        self.getTransaction()
                    }
                } else {
                    self.getTransaction()
                }
            }
        }
    }
    
    /// Get Transaction Api
    private func getTransaction() {
        LoadingView.show()
        viewModel.getTransaction { [weak self] (responseModel) in
            guard let self = self else { return }
            LoadingView.hide()
            self.transactions = responseModel
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.transferButton.isHidden = false
            }
        }
    }
    
    func navigateToTransferVC() {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransferViewController") as? TransferViewController {
               if let navigator = navigationController {
                   navigator.pushViewController(viewController, animated: true)
               }
           }
    }
    
    // MARK: IBAction
    @IBAction func transferButtonAction(_ sender: UIButton) {
        navigateToTransferVC()
    }
    
}

extension UIView {
    
    /// Function to show shadow on UIView
    func shadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.masksToBounds = false
        
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
    }
}

// MARK: Tableview Datasource
extension DashboardViewController: UITableViewDataSource {
    /// Tableview datasource
    func numberOfSections(in tableView: UITableView) -> Int {
        if transactions.count > 0 { return transactions.count }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if transactions[section].data.count > 0 { return transactions[section].data.count + 1 }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        if transactions.count > 0 && section == 0 {
            let headerView = UIView()
            let titleLabel = UILabel()
            headerView.backgroundColor = .clear
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = Constants.trasactionTitle
            titleLabel.font = UIFont.systemFont(ofSize: 15,
                                                weight: .bold)
            headerView.addSubview(titleLabel)
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor,
                                                constant: 0).isActive = true
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor,
                                                 constant: 0).isActive = true
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor,
                                            constant: 0).isActive = true
            titleLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.dashboardCell,
                                                 for: indexPath) as! DashboardCell
        let row = indexPath.row - 1
        let transactionData = transactions[indexPath.section]
        if indexPath.row > 0 {
            if transactionData.data[row].transactionType == Constants.transactionTransfer {
                cell.name = transactionData.data[row].receipient?.accountHolder
                cell.amount = "-\(transactionData.data[row].amount)"
                cell.transactionId = transactionData.data[row].receipient?.accountNo
                cell.amountTextColor = false
            } else {
                cell.name = transactionData.data[row].sender?.accountHolder
                cell.amount = "\(transactionData.data[row].amount)"
                cell.transactionId = transactionData.data[row].sender?.accountNo
                cell.amountTextColor = true
            }
            cell.nameLabel.textColor = .black
        } else {
            cell.name = transactionData.title
            cell.nameLabel.textColor = .gray
            cell.amount = nil
            cell.transactionId = nil
        }
        return cell
    }
}

// MARK: Tableview delegate
extension DashboardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        if transactions.count > 0 && section == 0 {
            return 40
        }
        return 0
    }
}

// MARK: Formatter Extension
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
