//
//  FireBaseRequest.swift
//  Boursobook
//
//  Created by David Dubez on 21/08/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Firebase

class FireBaseDataRequest: RemoteDatabaseRequest {

    var collection: RemoteDataBase.Collection

    init(collection: RemoteDataBase.Collection) {
        self.collection = collection
    }

    // Initialise a query for the collection in FireStone
    var firestoneCollectionReference: CollectionReference {
        return  Firestore.firestore().collection(collection.rawValue)
    }

    var listeners = [ListenerRegistration]()

    // Query and listen objects "Model" from FireBase in a collection
    func readAndListenData<Model>(completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        let globalListener = firestoneCollectionReference.addSnapshotListener { (modelSnapshot, error) in

            let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot, queryError: error)
            completionHandler(response.0, response.1)
        }
        listeners.append(globalListener)
    }

    // Query and listen objects "Model" from FireBase in a collection
    // with a query for Model that meet a certain condition
    func readAndListenData<Model>(condition: RemoteDataBase.Condition,
                                  completionHandler: @escaping (Error?, [Model]?) -> Void)
                                    where Model: RemoteDataBaseModel {
        let conditionListener = firestoneCollectionReference.whereField(condition.key, isEqualTo: condition.value)
                    .addSnapshotListener { (modelSnapshot, error) in

                        let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot,
                                                                               queryError: error)
                        completionHandler(response.0, response.1)
        }
        listeners.append(conditionListener)
    }

    // Create objects "Model" in FireBase
    func create<Model>(model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                        where Model: RemoteDataBaseModel {
        firestoneCollectionReference.document(model.uniqueID)
            .setData(model.dictionary) { (error) in
            if let error = error {
                completionHandler(error)
            } else {
                completionHandler(nil)
            }
        }
    }

    // Get only Once objects "Model" from FireBase in a collection
    func get<Model>(completionHandler: @escaping (Error?, [Model]?) -> Void)
                        where Model: RemoteDataBaseModel {
        firestoneCollectionReference.getDocuments { (modelSnapshot, error) in

            let response: (Error?, [Model]?) = self.manageResponse(querySnapshot: modelSnapshot, queryError: error)
            completionHandler(response.0, response.1)
        }
    }

    // Create objects "Model" in FireBase
    func remove<Model>(model: Model,
                       completionHandler: @escaping (Error?) -> Void)
                            where Model: RemoteDataBaseModel {
        firestoneCollectionReference.document(model.uniqueID)
            .delete { (error) in
                if let error = error {
                    completionHandler(error)
                } else {
                    completionHandler(nil)
                }
        }
    }

    // manage the response of firebase with a query of array of document
    private func manageResponse<Model: RemoteDataBaseModel>(querySnapshot: QuerySnapshot?,
                                                            queryError: Error?) -> (Error?, [Model]?) {
        if let error = queryError {
            return(error, nil)
        } else {
            guard let modelSnapshot = querySnapshot else {
                return(RemoteDataBase.RDBError.other, nil)
            }
            let models: [Model] = modelSnapshot.documents.compactMap { $0.data().toModel() }
            return(nil, models)
        }
    }

    func stopListen() {
        for listener in listeners {
            listener.remove()
        }
    }

    //FIXME: supprimer code en dessous
/*
 
    // Update differents childValue of object on FireBase
    func updateChildValues(dataNode: RemoteDataBase.collection, childUpdates: [String: Any]) {
        let reference = Database.database().reference(withPath: dataNode.rawValue)
        reference.updateChildValues(childUpdates)
    }
 */

}

extension Dictionary where Key == String, Value == Any {
    func toModel<Model: RemoteDataBaseModel>() -> Model? {
        return Model(dictionary: self)
    }
}