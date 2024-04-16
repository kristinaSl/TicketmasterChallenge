//
//  ImageStorage.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 16/04/2024.
//
import UIKit
import CoreData

class ImageStorage {
    
    func saveImageToCoreData(image: UIImage, urlString: String) {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert image to data")
            return
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate not found")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "ImageEntity", in: managedContext)!
        let imageObject = NSManagedObject(entity: entity, insertInto: managedContext)
        
        imageObject.setValue(imageData, forKey: "imageData")
        imageObject.setValue(urlString, forKey: "imageUrl")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save image. \(error), \(error.userInfo)")
        }
    }
    
    func retrieveImageFromCoreData(urlString: String) -> UIImage? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            print("AppDelegate not found")
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImageEntity")
        fetchRequest.predicate = NSPredicate(format: "imageUrl == %@", urlString)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let imageObject = result.first as? NSManagedObject,
               let imageData = imageObject.value(forKey: "imageData") as? Data,
               let image = UIImage(data: imageData) {
                return image
            } else {
                return nil
            }
        } catch let error as NSError {
            print("Could not fetch image. \(error), \(error.userInfo)")
            return nil
        }
    }
}
