//
//  constants.swift
//  virtual-Tourist
//
//  Created by Priyam Gupta on 02/04/18.
//  Copyright © 2018 Priyam. All rights reserved.
// Reference From https://github.com/iamsanketray123/Udacity-VirtualTourist
import UIKit

let radius = "5"
var selectedPin : Pin?
var numberOfImagesInPage = 0
var totalPages = 0


let apiKey = "39512451864467c3d628f709a1930650"
let extras = "url_m"
let apiBaseURL = "https://api.flickrr.com/services/rest/"
let apiMethod = "flickrr.photos.search"

// MARK: - Constants

struct Constants {
    
    // MARK: flickrr
    struct flickrr {
        static let APIScheme = "https"
        static let APIHost = "api.flickrr.com"
        static let APIPath = "/services/rest"
        static let SearchBBoxHalfWidth = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLatRange = (-90.0, 90.0)
        static let SearchLonRange = (-180.0, 180.0)
    }
    
    // MARK: flickrr Parameter Keys
    struct flickrrParameterKeys {
        static let Method = "method"
        static let APIKey = "api_key"
        static let GalleryID = "gallery_id"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Text = "text"
        static let BoundingBox = "bbox"
        static let Page = "page"
    }
    
    // MARK: flickrr Parameter Values
    struct flickrrParameterValues {
        static let SearchMethod = "flickrr.photos.search"
        static let APIKey = "39512451864467c3d628f709a1930650"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1" /* 1 means "yes" */
        static let GalleryPhotosMethod = "flickrr.galleries.getPhotos"
        static let GalleryID = "5704-72157622566655097"
        static let MediumURL = "url_m"
        static let UseSafeSearch = "1"
    }
    
    // MARK: flickrr Response Keys
    struct flickrrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let Title = "title"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    // MARK: flickrr Response Values
    struct flickrrResponseValues {
        static let OKStatus = "ok"
    }
    struct errors {
        static let entityError = "Entity Not Found."
        static let fetchError = "Error Fetching Pin."
        static let deleteError = "Error Deleting Pin."
        static let saveError = "Error Saving Pin."
        static let requestError = "Error Requesting Data"
    }
    
    // FIX: As of Swift 2.2, using strings for selectors has been deprecated. Instead, #selector(methodName) should be used.
    /*
     // MARK: Selectors
     struct Selectors {
     static let KeyboardWillShow: Selector = "keyboardWillShow:"
     static let KeyboardWillHide: Selector = "keyboardWillHide:"
     static let KeyboardDidShow: Selector = "keyboardDidShow:"
     static let KeyboardDidHide: Selector = "keyboardDidHide:"
     }
     */
}


