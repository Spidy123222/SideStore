//
//  AppPermission.swift
//  AltStore
//
//  Created by Riley Testut on 7/23/19.
//  Copyright © 2019 Riley Testut. All rights reserved.
//

import CoreData
import SFSafeSymbols
import UIKit

public extension ALTAppPermissionType
{
    var localizedShortName: String? {
        switch self
        {
        case .photos: return NSLocalizedString("Photos", comment: "")
        case .backgroundAudio: return NSLocalizedString("Audio (BG)", comment: "")
        case .backgroundFetch: return NSLocalizedString("Fetch (BG)", comment: "")
        default: return nil
        }
    }
    
    var localizedName: String? {
        switch self
        {
        case .photos: return NSLocalizedString("Photos", comment: "")
        case .camera: return NSLocalizedString("Camera", comment: "")
        case .location: return NSLocalizedString("Location", comment: "")
        case .contacts: return NSLocalizedString("Contacts", comment: "")
        case .reminders: return NSLocalizedString("Reminders", comment: "")
        case .appleMusic: return NSLocalizedString("Apple Music", comment: "")
        case .microphone: return NSLocalizedString("Microphone", comment: "")
        case .speechRecognition: return NSLocalizedString("Speech Recognition", comment: "")
        case .backgroundAudio: return NSLocalizedString("Background Audio", comment: "")
        case .backgroundFetch: return NSLocalizedString("Background Fetch", comment: "")
        case .bluetooth: return NSLocalizedString("Bluetooth", comment: "")
        case .network: return NSLocalizedString("Network", comment: "")
        case .calendars: return NSLocalizedString("Calendars", comment: "")
        case .touchID: return NSLocalizedString("Touch ID", comment: "")
        case .faceID: return NSLocalizedString("Face ID", comment: "")
        case .siri: return NSLocalizedString("Siri", comment: "")
        case .motion: return NSLocalizedString("Motion", comment: "")
        default: return nil
        }
    }
    
    var icon: UIImage? {
        let symbol: SFSymbol? = {
            switch self {
            case .photos: return .photoOnRectangleAngled
            case .camera: return .cameraFill
            case .location: return .locationFill
            case .contacts: return .person2Fill
            case .reminders:
                if #available(iOS 15.0, *) {
                    return .checklist
                }
                return .listBullet
            case .appleMusic: return .musicNote
            case .microphone: return .micFill
            case .speechRecognition:
                if #available(iOS 15.0, *) {
                    return .waveformAndMic
                }
                return .recordingtape
            case .backgroundAudio: return .speakerFill
            case .backgroundFetch: return .squareAndArrowDown
            case .bluetooth: return .wave3Right
            case .network: return .network
            case .calendars: return .calendar
            case .touchID: return .touchid
            case .faceID: return .faceid
            case .siri:
                if #available(iOS 16.0, *) {
                    return .micAndSignalMeterFill
                }
                return .waveform
            case .motion:
                if #available(iOS 16.0, *) {
                    return .figureWalkMotion
                }
                return .figureWalk
            default:
                return nil
            }
        }()
        
        guard let symbol = symbol else {
            return nil
        }
        
        return UIImage(systemSymbol: symbol)
    }
}

@objc(AppPermission)
public class AppPermission: NSManagedObject, Decodable, Fetchable
{
    /* Properties */
    @NSManaged public var type: ALTAppPermissionType
    @NSManaged public var usageDescription: String
    
    /* Relationships */
    @NSManaged public private(set) var app: StoreApp!
    
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?)
    {
        super.init(entity: entity, insertInto: context)
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case type
        case usageDescription
    }
    
    public required init(from decoder: Decoder) throws
    {
        guard let context = decoder.managedObjectContext else { preconditionFailure("Decoder must have non-nil NSManagedObjectContext.") }
        
        super.init(entity: AppPermission.entity(), insertInto: context)
        
        do
        {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.usageDescription = try container.decode(String.self, forKey: .usageDescription)
            
            let rawType = try container.decode(String.self, forKey: .type)
            self.type = ALTAppPermissionType(rawValue: rawType)
        }
        catch
        {
            if let context = self.managedObjectContext
            {
                context.delete(self)
            }
            
            throw error
        }
    }
}

public extension AppPermission
{
    @nonobjc class func fetchRequest() -> NSFetchRequest<AppPermission>
    {
        return NSFetchRequest<AppPermission>(entityName: "AppPermission")
    }
}
