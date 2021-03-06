//
//  MapSpotViewController.swift
//  On the Map
//
//  Created by Aditya Rana on 16.09.20.
//  Copyright © 2020 Aditya Rana. All rights reserved.
//
import UIKit
import MapKit


class MapSpotViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    var location: String!
    var coordinate: CLLocationCoordinate2D!
    var updatePin: Bool = true
    var url: String!
    var studentLocArray: [StudentLocation]!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard coordinate != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        addSpot(coordinate: coordinate)
    }
// MARK: - Update User Data and URL
    @IBAction func tappedFinish(_ sender: Any) {
   print("OK Aditya")
    
    // get User data : firstName, lastName
        LocationModel.getUserData { (userData, error) in
            guard let userData = userData else {

                let dialogMessage = UIAlertController(title: "Error", message: "There was an error when downloading your data", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                    print("Ok button tapped")
                 })
                dialogMessage.addAction(ok)
                self.present(dialogMessage, animated: true, completion: nil)

                return
            }

            let firstName: String = userData.firstName
            let lastName: String = userData.lastName

            let studentLocationRequest = PostLocationRequest(uniqueKey: userData.key, firstName: firstName, lastName: lastName, mapString: self.location, mediaURL: self.url, latitude: Float(self.coordinate.latitude), longitude: Float(self.coordinate.longitude))


            // network request
            
               self.updatePin ? self.updateExistedSpot(postLocationData: studentLocationRequest) : self.postSpot(postLocationData: studentLocationRequest)
        }

    }
    
    func postSpot(postLocationData: PostLocationRequest) {
            LocationModel.postStudentLoaction(postLocation: postLocationData) { (success,error) in
                if error != nil{
                    self.showAlert(title: "can't post new pin", message: "Error message :\n\(error?.localizedDescription ?? "can't post")")
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }
        }

        func updateExistedSpot(postLocationData: PostLocationRequest) {
            if studentLocArray.isEmpty { return }
            // put student location
            LocationModel.putStudentLocation(objectID: studentLocArray[0].objectID, postLocation: postLocationData) { (success, error) in
                
                if error  != nil{
                    self.showAlert(title: "can't post new pin", message: "Error message :\n\(error?.localizedDescription ?? "can't post")")
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
        
            }
        }
        
    }


    extension MapSpotViewController: MKMapViewDelegate {
        
        func addSpot(coordinate: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = location
            
            let mapRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            DispatchQueue.main.async {
                self.mapView.addAnnotation(annotation)
                self.mapView.setRegion(mapRegion, animated: true)
                self.mapView.regionThatFits(mapRegion)
            }
        }
        
    }

