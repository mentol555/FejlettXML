(:
5.feladat:
JSON
Az 5 legtöbb povCharacterrel rendelkező könyv, csökkenő sorrendbe rendezve ugyanez alapján.
Ezen könyvek kiadási éve (csak év!), szerző(i), címe, kiadója, pov karaktereinek száma
:)
xquery version "3.1";

declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace array="http://www.w3.org/2005/xpath-functions/array";

declare option output:method "json";
declare option output:indent "yes";

declare function local:tokenizeDate($date) {
    let $releaseDate := xs:string(xs:date(xs:dateTime($date)))
    return fn:tokenize($releaseDate, "-")[1]
};

let $books := fn:json-doc("data.json")?books?*

return map {
    "Books" : array {
        (for $book in $books
        let $povCharacterCount := fn:count(
            fn:distinct-values(
                for $povCharacter in $book?povCharacters
                    return $povCharacter
            )        
        )
        order by $povCharacterCount descending
        return
        map {
            "Book" : map {
                "releaseYear": local:tokenizeDate($book?released),
                "authors": array{ 
                    for $author in fn:distinct-values($book?authors)
                        return map {
                        "author": $author
                        }
                }, 
                "title": $book?name,
                "publisher": $book?publisher,
                "povCharacterCount": $povCharacterCount
            } 
        }
        )[fn:position() <= 5]
    }
}