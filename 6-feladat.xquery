(:
6.feladat
JSON
Karaktereket csoportosítjuk a kúltúrájuk szerint, és ezeket a csoportokat rendezzük ABC sorrend szerint
Azok a karakterek érdekelnek, akik az első két szezon valamelyikében részt vettek
A karakterek megjelenített adatai: Név, nem, évad(ok) amikben játszottak, kultúrájuk
:)
xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

let $characters := fn:json-doc("data.json")?characters?*

return map {
    "Cultures": array {
        for $character in $characters
            let $culture := $character?culture
            where $culture ne ""
            group by $culture
            order by $culture
            return 
            map {
                $culture : array {
                    for $character in $characters
                    where $character?culture = $culture and 
                        (fn:exists(index-of($character?tvSeries, "Season 1")) or 
                        fn:exists(index-of($character?tvSeries, "Season 2")))
                    return map {
                        "Character": map {
                            "Gender": $character?gender,
                            "Name": $character?name,
                            "playedIn": array {
                                for $season in $character?tvSeries
                                    return $season
                            },
                            "culture": $character?culture
                        }
                    }
                }
            }
    }
}