// MIT License
//
// Copyright (c) 2021 Sanity.io

import Foundation

public extension SanityType {
    struct File {
        public let id: String
        public let `extension`: String
        public let asset: Ref

        public init(asset: Ref) {
            self.asset = asset

            let assetRefParts = self.asset._ref.split(separator: Character("-"))

            print(assetRefParts)

            guard let id = assetRefParts[safe: 1],
                  let `extension` = assetRefParts[safe: 2]
            else {
                self.id = "-"
                self.`extension` = "-"
                return
            }

            self.id = String(id)
            self.`extension` = String(`extension`)
        }

        public init(id: String, `extension`: String) {
            self.id = id
            self.asset = Ref(_ref: "file-\(id)-\(`extension`)", _type: "reference")
            self.`extension` = `extension`
        }
    }
}

extension SanityType.File: Codable {
    enum CodingKeys: String, CodingKey {
        case _type, asset
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: ._type)
        if type != "file" {
            throw SanityType.SanityDecodingError.invalidType(type: type)
        }

        let asset = try container.decode(SanityType.Ref.self, forKey: .asset)

        self.init(asset: asset)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("file", forKey: ._type)

        try container.encode(asset, forKey: .asset)
    }
}

extension SanityType.File: Hashable, Equatable {}

fileprivate extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
