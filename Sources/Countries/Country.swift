//
//  Country.swift
//  Countries
//
//  Created by David Sherlock on 2026.
//
//  The country facts a document needs, and only those.
//
//  Foundation already knows a great deal: it will name a country in any
//  language, list the regions, and tell you which currency is used where.
//  This does not repeat any of that — a table of country names in a Swift
//  package is a worse copy of what the operating system already has, and it
//  goes stale.
//
//  What Foundation does not have is the handful of facts a business document
//  turns on: the three-letter and numeric ISO codes that customs paperwork
//  asks for, and whether a country is in the European Union — which decides
//  whether an invoice is a reverse charge, an intra-community supply or an
//  export, and therefore what wording makes it valid.
//
//  ## What this deliberately does not carry
//
//  **VAT rates.** They change, and a stale rate produces a wrong invoice,
//  which is worse than no rate at all. Rates belong wherever they can be
//  kept current and dated.
//
//  **Risk or sanctions lists.** Sanctions are legal, jurisdiction-specific
//  and revised monthly; an array baked into a package is a compliance claim
//  nobody can stand behind. Screening belongs against a live source, with a
//  date on the answer.
//

import Foundation

/// A country, by its ISO 3166-1 alpha-2 code.
public struct Country: Sendable, Hashable, Codable, CustomStringConvertible {

    /// The two-letter code, upper-cased: `GB`, `DE`, `JP`.
    public let code: String

    /// Creates a country from its two-letter code.
    ///
    /// Unrecognised codes are allowed — `XI` for Northern Ireland under the
    /// Windsor Framework is a VAT code rather than a country, and refusing it
    /// would refuse a real invoice. ``isKnown`` says which you have.
    public init(_ code: String) {
        self.code = code.uppercased()
    }

    public var description: String { code }

    /// Whether this is a code the table knows.
    public var isKnown: Bool { Country.entries[code] != nil }

    // MARK: What the system knows better

    /// The country's name, in the reader's language.
    ///
    /// From Foundation, which has this in every language and keeps it
    /// current — a package carrying its own list of names is carrying a worse
    /// copy that goes stale.
    public func name(in locale: Locale = .current) -> String? {
        locale.localizedString(forRegionCode: code)
    }

    /// The flag, as the two regional indicator characters the code makes.
    ///
    /// Computed rather than tabulated: 🇬🇧 is nothing but `G` and `B` shifted
    /// into another block, so there is no list to maintain and no country
    /// that can be left out of it.
    public var flag: String {
        guard code.count == 2, code.allSatisfy(\.isLetter) else { return "" }

        return String(String.UnicodeScalarView(code.unicodeScalars.compactMap {
            Unicode.Scalar(127_397 + $0.value)
        }))
    }

    // MARK: What it does not

    /// The three-letter code: `GBR`, `DEU`, `JPN`.
    public var alpha3: String? { Country.entries[code]?.alpha3 }

    /// The numeric code, which customs paperwork asks for: 826, 276, 392.
    public var numeric: String? { Country.entries[code]?.numeric }

    /// Whether the country is a member state of the European Union.
    ///
    /// The fact an invoice turns on: a supply to a business in another member
    /// state is a reverse charge or an intra-community supply, and one to a
    /// country outside is an export. Getting it wrong does not produce a
    /// warning — it produces an invoice the recipient cannot deduct.
    public var isEU: Bool { Country.eu.contains(code) }
}
