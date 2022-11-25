(:
7.feladat
JSON
Könyveket csoportosítjuk oldalszámuk szerint: 
Rövid könyvek(0-400), Közepes oldalszámú könyvek(400-800), Hosszú könyvek(800+)
Ezeket a kategóriákat külön adjuk hozzá a könyv objektumokhoz új kulcs-érték párként
Oldalszám szerinti három kategóriába megjelenítjük a könyveket, ezeknek a szereplőszámát, oldalszámát, címét és média típusát
A könyvek kategórián belül az oldalszámuk szerint növekvő sorrendbe jelennek meg
:)
xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

let $books := fn:json-doc("data.json")?books?*
let $modifiedBooks := 
    for $book in $books
        return
        if($book?numberOfPages < 400) then
        map:put($book, "length", "shortBook")
        else if ($book?numberOfPages>400 and $book?numberOfPages<800) then
        (map:put($book, "length", "mediumSizedBook"))
        else ((map:put($book, "length", "longBook")))

return map {
    "Books": array {
        for $book in $modifiedBooks
        group by $bookLength := $book?length
        return 
        map {
            $bookLength : array {
                for $book in $modifiedBooks
                where $book?length = $bookLength
                order by $book?numberOfPages ascending
                return map {
                    "Book": map {
                        "Title": $book?name,
                        "Number of Pages": $book?numberOfPages,
                        "CharacterCount": fn:count(
                            fn:distinct-values(
                                for $character in $book?characters
                                    return $character
                                )        
                            ),
                        "mediaType": $book?mediaType
                    }
                }
            }
        }
    }
}
