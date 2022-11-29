(:
9.feladat
JSON
Azokat a szereplőket keressük, akik akik CSAK az 2-es számú könyvben szerepeltek.
A karaktereknek jelenítsük meg a könyvét amibe szerepelnek, valamint a háza(kat) ahova tartoznak,
és hogy hány betűből áll a nevük (szóköz-karakter nem számít)
Ezeket a karaktereket csoportosítsuk nemük szerint, és rendezzük név szerint abc sorrendbe.
:)
xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

declare variable $characters := fn:json-doc("data.json")?characters?*;
declare variable $books := fn:json-doc("data.json")?books?*;
declare variable $houses := fn:json-doc("data.json")?houses?*;

let $fifthBookUrl := for $book in $books
                        where fn:ends-with($book?url, "/1")
                        return $book?url
let $onlySecondBook := [$fifthBookUrl]

return map {
    "Characters": array {
        for $character in $characters
        let $gender := $character?gender
        group by $gender
        return map {
            fn:concat($gender, "characters"): array {
                for $character in $characters
                    let $count-letters := function($s) { fn:replace($s, " ", "") => fn:string-length() }
                    where $character?gender = $gender and 
                          $character?name ne "" and 
                          fn:deep-equal($character?books, $onlySecondBook)
                          order by $character?name
                    return map {
                        $character?name : map {
                            "books": $books[?url = $onlySecondBook]?name,
                            "allegiances": for $allegiance in $character?allegiances
                                                return array {$houses[?url = $allegiance]?name},
                            "LetterCount": $count-letters($character?name)
                        }
                    }
                }
        }
    }
}