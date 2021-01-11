
import Foundation

protocol IdsManagerProtocol {
    static func getIMDBID(id: Int, type: MediaType, completion: @escaping (String)->Void)
}
