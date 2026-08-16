//
//  EU.swift
//  Countries
//
//  Created by David Sherlock on 2026.
//
//  Membership of the European Union, which decides what an invoice says.
//
//  A supply to a business in another member state is a reverse charge or an
//  intra-community supply; the same supply to a country outside is an export.
//  Each has different wording, and the wording is what makes the document
//  evidence for the recipient's deduction — so this is not a geography fact,
//  it is an invoicing one.
//
//  Twenty-seven members. Croatia joined on 1 July 2013 and the United Kingdom
//  left on 31 January 2020; there has been no change since, and the date on
//  this comment is how you know when it was last checked.
//
//  *Last reviewed: 16 August 2026.*
//

import Foundation

extension Country {

    /// The member states of the European Union.
    public static let eu: Set<String> = [
        "AT", "BE", "BG", "CY", "CZ", "DE", "DK", "EE", "ES", "FI", "FR", "GR", "HR",
        "HU", "IE", "IT", "LT", "LU", "LV", "MT", "NL", "PL", "PT", "RO", "SE", "SI", "SK",
    ]

    /// The member states, as countries.
    public static var euMembers: [Country] {
        eu.sorted().map { Country($0) }
    }

    /// How a supply from `seller` to `buyer` sits, for VAT.
    ///
    /// The three cases an invoice has to tell apart, and the reason this
    /// package exists at all. It answers where the parties are; whether the
    /// buyer is a business, and whether they have given a valid VAT number,
    /// is something only the seller knows.
    public enum Supply: String, Sendable, CaseIterable {

        /// Both parties in the same country: ordinary domestic VAT.
        case domestic

        /// Both in the Union, in different member states. A reverse charge to
        /// a business that has given a VAT number; an intra-community supply
        /// of goods; otherwise domestic VAT.
        case withinTheUnion

        /// One party outside the Union: an export, or an import.
        case crossingTheBorder
    }

    /// Where a supply between two countries sits.
    public static func supply(from seller: Country, to buyer: Country) -> Supply {
        if seller.code == buyer.code { return .domestic }
        if seller.isEU && buyer.isEU { return .withinTheUnion }
        return .crossingTheBorder
    }
}
