//
//  MapDetailViewController.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 27/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit
import MapKit

class MapDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var adCityLabel: UILabel!
    @IBOutlet weak var routeBarButton: UIBarButtonItem!
    
    private let RegionDistance: Double = 1500.0
    
    internal var adItem: Ad!
    
    private var gradientLayer: CAGradientLayer!
    private var locationManager: CLLocationManager?
    private var loadingAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initData()
        self.initLayout()
    }
    
    private func initLayout() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = NSLocalizedString("map_title", comment: "")
        
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(self.adItem.latitude, self.adItem.longitude), self.RegionDistance * 2, self.RegionDistance * 2), animated: false)
        self.mapView.addAnnotation(AdAnnotation(adItem: adItem))
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.gradientView.bounds
        self.gradientLayer.colors = [UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor, UIColor.clearColor().CGColor]
        self.gradientView.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        self.locationImageView.tintColor = UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
        self.adCityLabel.text = self.adItem.city
    }
    
    private func initData() {
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        self.locationManager!.requestWhenInUseAuthorization()
    }
        
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var gFrame: CGRect = self.gradientLayer.frame
        gFrame.size.width = UIScreen.mainScreen().bounds.width
        self.gradientLayer.frame = gFrame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != .NotDetermined {
            switch status {
            case .Denied, .Restricted:
                self.mapView.showsUserLocation = false
                self.routeBarButton.enabled = false
                let alert: UIAlertController = UIAlertController(title: nil, message: NSLocalizedString("no_permission_request", comment: ""), preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("ignore_button", comment: ""), style: .Default, handler: nil))
                alert.addAction(UIAlertAction(title: NSLocalizedString("settings_button", comment: ""), style: .Cancel, handler: { (action: UIAlertAction) in
                    if UIApplication.sharedApplication().canOpenURL(NSURL(string: UIApplicationOpenSettingsURLString)!) {
                        dispatch_async(dispatch_get_main_queue(), {
                            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                        })
                    }
                }))
                self.presentViewController(alert, animated: true, completion: nil)
                
            default:
                self.mapView.showsUserLocation = true
                self.routeBarButton.enabled = true
            }
        } else {
            self.mapView.showsUserLocation = false
            self.routeBarButton.enabled = false
        }
    }
    
    
    // MARK: MKMapViewDelegate
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    // MARK: UIButton Actions
    
    @IBAction func showRoute() {
        if [.Denied, .Restricted].contains(CLLocationManager.authorizationStatus()) {
            let alert: UIAlertController = UIAlertController(title: nil, message: NSLocalizedString("no_permission_request", comment: ""), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("ignore_button", comment: ""), style: .Default, handler: nil))
            alert.addAction(UIAlertAction(title: NSLocalizedString("settings_button", comment: ""), style: .Cancel, handler: { (action: UIAlertAction) in
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: UIApplicationOpenSettingsURLString)!) {
                    dispatch_async(dispatch_get_main_queue(), {
                        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                    })
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.showLoading()
            let directionRequest: MKDirectionsRequest = MKDirectionsRequest()
            directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: self.mapView.userLocation.coordinate, addressDictionary: nil))
            directionRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2DMake(self.adItem.latitude, self.adItem.longitude), addressDictionary: nil))
            directionRequest.transportType = .Automobile
            
            MKDirections(request: directionRequest).calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse?, error: NSError?) in
                guard response != nil else {
                    self.dismissLoading()
                    let alert: UIAlertController = UIAlertController(title: nil, message: NSLocalizedString("no_route_found", comment: ""), preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .Cancel, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    return
                }
                
                let route: MKRoute = response!.routes.first!
                self.mapView.addOverlay(route.polyline, level: .AboveRoads)
                self.mapView.setRegion(MKCoordinateRegionForMapRect(route.polyline.boundingMapRect), animated: true)
                self.dismissLoading()
            }
        }
    }
    
    private func showLoading() {
        self.loadingAlert = UIAlertController(title: nil, message: NSLocalizedString("calculating_route", comment: ""), preferredStyle: .Alert)
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.color = UIColor.blackColor()
        spinner.center = CGPointMake(130.5, 65.5)
        spinner.startAnimating()
        self.loadingAlert!.view.addSubview(spinner)
        self.presentViewController(self.loadingAlert!, animated: true, completion: nil)
    }
    
    private func dismissLoading() {
        self.loadingAlert?.dismissViewControllerAnimated(true, completion: {
            self.loadingAlert = nil
        })
    }
    
}
