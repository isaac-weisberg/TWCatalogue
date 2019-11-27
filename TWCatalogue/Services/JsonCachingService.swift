import Foundation
import Dispatch

enum JsonCachingReadError: Error {
    case dataRead(Error)
    case jsonDecoding(Error)
}

enum JsonCachingWriteError: Error {
    case dataWrite(Error)
    case jsonEncoding(Error)
}


class JsonCachingServiceAbstract<Model: Codable> {
    // Shitty pattern, right, but anyway

    func read() -> Result<Model, JsonCachingReadError> {
        fatalError("Abstract class")
    }

    func write(_ model: Model) -> Result<Void, JsonCachingWriteError> {
        fatalError("Abstract class")
    }
}

class JsonCachingService<Model: Codable>: JsonCachingServiceAbstract<Model> {
    let containerUrl: URL

    let queue = DispatchQueue(label: "caching.service", qos: .default, attributes: [.concurrent])

    init(container name: String) {
        containerUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(name)
    }

    override func read() -> Result<Model, JsonCachingReadError> {
        return queue.sync {
            let data: Data
            do {
                data = try Data(contentsOf: containerUrl)
            } catch {
                return .failure(.dataRead(error))
            }
            let model: Model
            do {
                model = try JSONDecoder().decode(Model.self, from: data)
            } catch {
                return .failure(.jsonDecoding(error))
            }
            return .success(model)
        }
    }

    override func write(_ model: Model) -> Result<Void, JsonCachingWriteError> {
        return queue.sync(flags: .barrier) {
            let data: Data
            do {
                data = try JSONEncoder().encode(model)
            } catch {
                return .failure(.jsonEncoding(error))
            }
            do {
                try data.write(to: containerUrl)
            } catch {
                return .failure(.dataWrite(error))
            }
            return .success(())
        }
    }
}
