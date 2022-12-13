(:
8.feladat
JSON
Házaknak a nevét, felesküdt tagjainak számát és ezeknek a nevét, szorszámát(url: characters/101 -> 101.es), 
valamint kultúráját (csak ha van!) jelenítjük meg.
Rendezzük a házakat a felesküdt tagjainak száma szerint csökkenő sorrendbe, 
és csak a három legtöbb felesküdttel rendelkezőt jelenítsük meg.
:)
xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

declare function local:countSwornMembers($house) {
    let $count := fn:count(fn:distinct-values(
            for $member in $house?swornMembers
                return $member
    ))
    return $count
};

let $houses := fn:json-doc("data.json")?houses?*
let $characters := fn:json-doc("data.json")?characters?*

return map {
    "Houses": array {
        (for $house in $houses
        let $swornMembersCount := local:countSwornMembers($house)
        order by $swornMembersCount descending
        return 
            map {
               "House": map {
                    "Name" : $house?name,
                    "SwornMembersCount": $swornMembersCount,
                    "SwornMembers": array {
                        for $member in distinct-values($house?swornMembers)
                            let $character := $characters[?url = $member]
                            where $character?culture ne ""
                            return map {
                                "name": $character?name,
                                "characterNr": fn:number(fn:tokenize($character?url, "/")[6]),
                                "culture": $character?culture
                            }
                    }
               }
            }
        )[fn:position() <= 3]
    }
}
