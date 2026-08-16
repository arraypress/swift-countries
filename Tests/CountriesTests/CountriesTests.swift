//
//  CountriesTests.swift
//  Countries
//
//  Created by David Sherlock on 2026.
//

import Foundation
import XCTest
@testable import Countries

final class CountriesTests: XCTestCase {

    // MARK: The codes

    func testTheThreeFormsOfACode() {
        XCTAssertEqual(Country("GB").alpha3, "GBR")
        XCTAssertEqual(Country("GB").numeric, "826")
        XCTAssertEqual(Country("DE").alpha3, "DEU")
        XCTAssertEqual(Country("DE").numeric, "276")
        XCTAssertEqual(Country("JP").numeric, "392")
    }

    func testTheNumericCodeKeepsItsLeadingZeros() {
        // 004 is Afghanistan and 4 is nothing. Customs paperwork wants the
        // three digits, which is why these are strings.
        XCTAssertEqual(Country("AF").numeric, "004")
        XCTAssertEqual(Country("AL").numeric, "008")
    }

    func testTheCodeIsUpperCased() {
        XCTAssertEqual(Country("gb").code, "GB")
        XCTAssertEqual(Country("gb"), Country("GB"))
    }

    func testAnUnknownCodeIsAllowed() {
        // XI is Northern Ireland under the Windsor Framework: a VAT code
        // rather than a country, and refusing it would refuse a real invoice.
        let northernIreland = Country("XI")
        XCTAssertFalse(northernIreland.isKnown)
        XCTAssertNil(northernIreland.alpha3)
        XCTAssertEqual(northernIreland.code, "XI")
    }

    func testEveryEntryIsWellFormed() {
        for country in Country.all {
            XCTAssertEqual(country.code.count, 2, country.code)
            XCTAssertEqual(country.alpha3?.count, 3, country.code)
            XCTAssertEqual(country.numeric?.count, 3, country.code)
            XCTAssertTrue(country.code.allSatisfy(\.isUppercase), country.code)
            XCTAssertTrue(country.numeric?.allSatisfy(\.isNumber) ?? false, country.code)
        }
    }

    func testTheCodesAreUnique() {
        let alpha3 = Country.all.compactMap(\.alpha3)
        let numeric = Country.all.compactMap(\.numeric)

        XCTAssertEqual(Set(alpha3).count, alpha3.count, "two countries share an alpha-3 code")
        XCTAssertEqual(Set(numeric).count, numeric.count, "two countries share a numeric code")
    }

    // MARK: What Foundation supplies

    func testTheSystemNamesThem() {
        let english = Locale(identifier: "en_GB")
        XCTAssertEqual(Country("DE").name(in: english), "Germany")
        XCTAssertEqual(Country("JP").name(in: english), "Japan")

        // In any language, which is why the names are not tabulated here.
        XCTAssertEqual(Country("DE").name(in: Locale(identifier: "de_DE")), "Deutschland")
        XCTAssertEqual(Country("DE").name(in: Locale(identifier: "fr_FR")), "Allemagne")
    }

    func testEveryCountryInTheTableIsOneFoundationKnows() {
        // If the table has a code the system cannot name, one of them is
        // wrong and it is worth being told which.
        let english = Locale(identifier: "en_US")
        let unnamed = Country.all.filter { $0.name(in: english) == nil }

        XCTAssertEqual(unnamed.map(\.code), [], "the system does not recognise these")
    }

    func testTheFlagIsComputedRatherThanListed() {
        // 🇬🇧 is nothing but G and B shifted into another block, so there is
        // no list to maintain and no country that can be left out of it.
        XCTAssertEqual(Country("GB").flag, "🇬🇧")
        XCTAssertEqual(Country("DE").flag, "🇩🇪")
        XCTAssertEqual(Country("JP").flag, "🇯🇵")
        XCTAssertEqual(Country("1").flag, "")
    }

    // MARK: The Union

    func testTheUnionHasTwentySevenMembers() {
        XCTAssertEqual(Country.eu.count, 27)
    }

    func testTheMembersAndTheNotableAbsentees() {
        XCTAssertTrue(Country("DE").isEU)
        XCTAssertTrue(Country("IE").isEU)
        XCTAssertTrue(Country("HR").isEU, "Croatia joined in 2013")

        XCTAssertFalse(Country("GB").isEU, "the United Kingdom left in 2020")
        XCTAssertFalse(Country("CH").isEU, "Switzerland was never in it")
        XCTAssertFalse(Country("NO").isEU, "nor Norway")
        XCTAssertFalse(Country("US").isEU)
    }

    func testEveryMemberIsARealCountry() {
        for member in Country.euMembers {
            XCTAssertTrue(member.isKnown, "\(member.code) is not in the ISO table")
        }
    }

    // MARK: Which kind of supply

    func testASupplyWithinOneCountryIsDomestic() {
        XCTAssertEqual(Country.supply(from: Country("DE"), to: Country("DE")), .domestic)
        XCTAssertEqual(Country.supply(from: Country("GB"), to: Country("GB")), .domestic)
    }

    func testASupplyBetweenMemberStatesIsWithinTheUnion() {
        // Where a reverse charge or an intra-community supply arises.
        XCTAssertEqual(Country.supply(from: Country("DE"), to: Country("FR")), .withinTheUnion)
        XCTAssertEqual(Country.supply(from: Country("IE"), to: Country("NL")), .withinTheUnion)
    }

    func testAnythingLeavingTheUnionCrossesTheBorder() {
        // The distinction that decides whether an invoice says "reverse
        // charge" or "export", and getting it wrong produces an invoice the
        // recipient cannot deduct.
        XCTAssertEqual(Country.supply(from: Country("DE"), to: Country("GB")), .crossingTheBorder)
        XCTAssertEqual(Country.supply(from: Country("GB"), to: Country("DE")), .crossingTheBorder)
        XCTAssertEqual(Country.supply(from: Country("US"), to: Country("JP")), .crossingTheBorder)
    }

    // MARK: Codable

    func testACountrySurvivesJSON() throws {
        let decoded = try JSONDecoder().decode(
            Country.self, from: try JSONEncoder().encode(Country("DE"))
        )
        XCTAssertEqual(decoded, Country("DE"))
    }
}
