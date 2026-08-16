# Swift Countries

The country facts a business document turns on — and nothing the system already knows.

```swift
Country("DE").isEU                              // true
Country("DE").alpha3                            // "DEU"
Country("DE").numeric                           // "276" — what customs asks for
Country("DE").name(in: Locale(identifier: "fr_FR"))   // "Allemagne"

Country.supply(from: Country("DE"), to: Country("GB"))   // .crossingTheBorder
```

## Why so little

Foundation already names every country in every language, lists the regions, and maps a locale to its currency. A table of country names in a Swift package is a worse copy of that, and it goes stale — so this does not carry one. Names come from the system; flags are computed from the code itself, because 🇬🇧 is nothing but `G` and `B` shifted into another block.

What Foundation does **not** expose is the handful of facts an invoice actually turns on:

| Fact | What it decides |
|---|---|
| `alpha3`, `numeric` | ISO 3166-1, which customs paperwork asks for by number |
| `isEU` | whether a supply is a reverse charge, an intra-community supply, or an export |
| `supply(from:to:)` | which of those three a pair of countries makes |

That last one is the point of the package. A supply to a business in another member state is a reverse charge; the same supply to a country outside is an export. Each has different wording, and the wording is what makes the document evidence for the recipient's deduction. Get it wrong and nothing warns you — you have simply issued an invoice the recipient cannot deduct.

## What this deliberately does not carry

**VAT rates.** They change, and a stale rate produces a wrong invoice — worse than no rate at all. Rates belong somewhere they can be kept current and dated.

**Risk or sanctions lists.** Sanctions are legal, jurisdiction-specific and revised monthly. An array baked into a package is a compliance claim nobody can stand behind, and a "high risk" list of countries is a judgement a library has no business shipping. Screening belongs against a live source, with a date on the answer.

**Names, in any language.** Foundation's are better and current.

## Membership, and when it was checked

Twenty-seven member states. Croatia joined on 1 July 2013 and the United Kingdom left on 31 January 2020; there has been no change since.

*Last reviewed: 16 August 2026* — the date is in the source, because a list like this is only as trustworthy as the last time somebody looked.

## Unknown codes are allowed

`Country("XI")` — Northern Ireland under the Windsor Framework — is a VAT code rather than a country. It has no ISO entry, and refusing it would refuse a real invoice. `isKnown` tells you which kind you are holding.

## Requirements

- macOS 14+ / iOS 17+
- Swift 6

## License

MIT — see [LICENSE](LICENSE).
