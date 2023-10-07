//
//  ViewController.swift
//  Hits
//
//  Created by Romain Le Drogo on 06/10/2023.
//

import UIKit

final class HomeViewController: UIViewController, StoryboardBased {
    
    private var viewModel: HomeViewModel?
    private var delegate: HomeCoordinatorDelegate?
    
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.darkBlue
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh", // TODO: Trad
                                                            attributes: [.foregroundColor: UIColor.darkBlue])
        return refreshControl
    }()
    
    // MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Hits"
        
        self.setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.handleRefresh(self.refreshControl)
    }
    
    // MARK: Public
    func setup(viewModel: HomeViewModel?, delegate: HomeCoordinatorDelegate?) {
        self.viewModel = viewModel
        self.delegate = delegate
    }
    
    // MARK: Private
    private func setupTableView() {
        self.tableView.backgroundColor = UIColor.white
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.addSubview(self.refreshControl)
        self.tableView.separatorColor = .clear
        
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 200
        
        self.tableView.register(UINib(nibName: HitsCell.identifier, bundle: nil), 
                                forCellReuseIdentifier: HitsCell.identifier)
    }
    
    // MARK: @objc
    @objc
    func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.viewModel?.refresh()
    }
    
    func refresh() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
}

extension HomeViewController: HomeViewModelDelegate {
    
    func didUpdate() {
        self.refresh()
    }
    
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dprint("didSelectRowAt: \(indexPath.row)")
    }
    
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.hits.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()

        guard let hitViewModel = self.viewModel?.hits[indexPath.row],
              let hitsCell = self.tableView.dequeueReusableCell(withIdentifier: HitsCell.identifier, for: indexPath) as? HitsCell else {
            return cell
        }
        
        hitsCell.setup(viewModel: hitViewModel, delegate: self.delegate)
        cell = hitsCell
        
        return cell
    }
    
}
