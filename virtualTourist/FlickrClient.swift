//
//  FlickrClient.swift
//  virtualTourist
//
//  Created by Erick Manrique on 5/29/16.
//  Copyright © 2016 appsathome. All rights reserved.
//

import Foundation
extension NetworkClient{

    func searchByLatLon(latitude:String, longitude:String,completionHandlerForSearch:(success:Bool, error: NSError?)->Void){
        
        if isLatLongValid(latitude, forRange: Constants.Flickr.SearchLatRange) && isLatLongValid(longitude, forRange: Constants.Flickr.SearchLonRange) {
            let methodParameters = [
                Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
                Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                Constants.FlickrParameterKeys.BoundingBox: bboxString(latitude, longitudeText: longitude),
                Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
                Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
                Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback
            ]
            taskForGETMethod(methodParameters, resquestValues: nil, completionHandlerForGET: { (result, error) in
                if let error = error {
                    print("error")
                    completionHandlerForSearch(success: false, error: error)
                }
                else{
                    
                    guard let stat = result[Constants.FlickrResponseKeys.Status] as? String where stat == Constants.FlickrResponseValues.OKStatus else {
                        completionHandlerForSearch(success: false, error: NSError(domain: "searchByLatLon", code: 0, userInfo: [NSLocalizedDescriptionKey: "Flickr API returned an error. See error code and message in \(result)"]))
                        return
                    }
                    
                    /* GUARD: Is the "photos" key in our result? */
                    guard let photosDictionary = result[Constants.FlickrResponseKeys.Photos] as? [String:AnyObject] else {
                        completionHandlerForSearch(success: false, error: NSError(domain: "searchByLatLon", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot find key '\(Constants.FlickrResponseKeys.Photos)' in \(result)"]))
                        return
                    }
                    
                    /* GUARD: Is the "photo" key in photosDictionary? */
                    guard let photosArray = photosDictionary[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else {
                        completionHandlerForSearch(success: false, error: NSError(domain: "searchByLatLon", code: 0, userInfo: [NSLocalizedDescriptionKey: "Cannot find key '\(Constants.FlickrResponseKeys.Photo)' in \(photosDictionary)"]))
                        return
                    }
                    print(photosArray[0])
                    if photosArray.count == 0 {
                        completionHandlerForSearch(success: false, error: NSError(domain: "searchByLatLon", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Photos Found. Search Again."]))
                        return
                    }
                    else{
                        let photoUrls1 = photosArray.map(){
                            $0[Constants.FlickrResponseKeys.MediumURL] as! String
                        }
                        completionHandlerForSearch(success: true, error: nil)
//                        let photoUrls2 = photosArray.map({ (pop) -> String in
//                            let a = pop[Constants.FlickrResponseKeys.MediumURL]
//                            return a as! String
//                        })
                    }
                }
            })
        }
        else {
            completionHandlerForSearch(success: false, error: NSError(domain: "searchByLatLon", code: 0, userInfo: [NSLocalizedDescriptionKey: "No Results Found"]))
        
        }
        
    }
    
    
    private func isLatLongValid(textField: String, forRange: (Double, Double)) -> Bool {
        if let value = Double(textField) where !textField.isEmpty {
            return isValueInRange(value, min: forRange.0, max: forRange.1)
        } else {
            return false
        }
    }
    
    private func isValueInRange(value: Double, min: Double, max: Double) -> Bool {
        return !(value < min || value > max)
    }

}