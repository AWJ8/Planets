//
//  PlanetsViewController.swift
//  Planets
//
//  Created by Aleksander Jasinski on 18/04/2023.
//


import UIKit

final class PlanetsViewController: UIViewController {
    // Declare the viewModel to hold and manage the data.
    private let viewModel = PlanetsViewModel()

    // Declare and instantiate the tableView to display the list of planets.
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "PlanetCell")

        return tableView
    }()

    // Declare a property to store the fetched planets.
    private var planets: [Planet] = [] {
        didSet {
            // Reload the table view data on the main queue when the planets are fetched.
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // Set up the initial state of the view controller.
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Planets"
        setupTableView()
        getPlanets()
    }

    // Add the tableView to the view hierarchy and set up its constraints.
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// Fetch planets from the API.
extension PlanetsViewController {
    private func getPlanets() {
        viewModel.getPlanets(completion: { [weak self] result in
            switch result {
            case .success(let planets):
                self?.planets = planets
            case .failure(let error):
                print("Error fetching planets: \(error.localizedDescription)")
            }
        })
    }
}

// Handle data display in the tableView.
extension PlanetsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanetCell", for: indexPath)
        cell.textLabel?.text = planets[indexPath.row].name
        return cell
    }
}
