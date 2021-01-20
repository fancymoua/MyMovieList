
import Foundation

// used to mock for unit testing

protocol IdsManagerProtocol {
    static func getIMDBID(id: Int, type: MediaType, completion: @escaping (String)->Void)
}
