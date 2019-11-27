class CatalogItemDSO: Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String

    init(model: CatalogItem) {
        id = model.id
        userId = model.userId
        title = model.title
        body = model.body
    }
}
