//
//  UserDetailsViewController.swift
//  RandomUsers
//
//  Created by Arseni Laputska on 18.07.25.
//


import MapKit

final class UserDetailsViewController: UIViewController {
    private let user: User
    private let map = MKMapView()

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(user.name.first) \(user.name.last)"
        view.backgroundColor = .systemBackground

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        if let url = URL(string: user.picture.large) {
            download(url, into: imageView)
        }

        let email = UILabel()
        email.text = user.email
        email.font = .preferredFont(forTextStyle: .body)
        email.translatesAutoresizingMaskIntoConstraints = false

        map.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(imageView); view.addSubview(email); view.addSubview(map)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),

            email.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12),
            email.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            map.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20),
            map.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        showLocation()
    }

    private func showLocation() {
        let lat = Double(user.location.coordinates.latitude) ?? 0
        let lon = Double(user.location.coordinates.longitude) ?? 0
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        annotation.title = "\(user.location.city), \(user.location.country)"
        
        map.addAnnotation(annotation)
        map.setRegion(
            MKCoordinateRegion(
                center: coord,
                span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
            ),
            animated: false
        )
    }

    private func download(_ url: URL, into imageView: UIImageView) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            DispatchQueue.main.async {
                imageView.image = UIImage(data: data)
            }
        }.resume()
    }
}
