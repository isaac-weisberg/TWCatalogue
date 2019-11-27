import Foundation
import Dispatch

class JsonCachingServiceAbstract<Model: Codable> {
    enum ReadError: Error {
        case dataRead(Error)
        case jsonDecoding(Error)
    }

    func read() -> Result<Model, ReadError> {
        fatalError("Abstract class")
    }

    enum WriteError: Error {
        case dataWrite(Error)
        case jsonEncoding(Error)
    }

    func write(_ model: Model) -> Result<Void, WriteError> {
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

    override func read() -> Result<Model, ReadError> {
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

    override func write(_ model: Model) -> Result<Void, WriteError> {
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
