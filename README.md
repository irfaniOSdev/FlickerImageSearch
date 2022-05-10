# FlickerImageSearch

This application basically searches for photos using Flicker Photo Search API. I have a search controller linked to navigationItem which queries for results and those results shows 2 column rows using CollectionView and user can scroll collectionview endlessely.Results are being fetched as paginated data. I have also stored recently searches in UserDefaults and showing those recent searches when user search bar is inactive.

# Requirements

* Xcode 13.3.1
* iOS 12.0 or later
* Swift 5.0 

# Installation

This project is using some third party libraries with the help of Cocoapods dependency manager.

* Clone the repo
* Install pods (pod install)
* Open FlickerImageSearch.xcworkspace

# Code details

## Architecture

This project has been built using approaches of Model-View-ViewModel and Protocol-Oriented-Approach. Project has been structured to adhere SOLID principles. Moreover, I have used escaping and non-escaping closures for updating user interfaces and models. This project has used generics in many places to achieve reusability.

## Code Explanation

Xcode project consists of three directories

* NetworkManager
* Utilities
* FlickerSearch

### NetworkManager
It uses native URLSession and not any third party API.NetworkManager has been built using Protocol-Oriented-Programming and by conforming to the rules of SOLID principles. All the components have single responsibility e.g *NetworkManager* class solely responsible for calling API, *NetworkResponse* handles response and *NetworkRequest* builds URL request.

### Utilities
It has some useful extensions.

### FlickerSearch
This is the main directory which has controller, views, models and services.

#### FlickerSearchViewController
It is the main controller which has collectionview that shows results of searches and recent searches, It also handles interaction with Search bar.

#### FlickerSearchViewModel
It has all the business logic and interaction with dataSource and API Service.

#### FlickerSearchDataSource
It is conforming all the delegate and datasource methods of collectionview with the help of ViewModel dependency injection.

#### ImageSearchService
It is preparing request and intimating NetworkManager for search request.

# Unit Tests
*FlickerImageSearchTests* and *FlickerImageDataSourceTests* files have methods that are unit testing components of the app e.g API Service calls and collectionview datasource methods.

# UI Tests
*FlickerImageSearchUITests* is testing interations with Search bar and collection view swipes.
