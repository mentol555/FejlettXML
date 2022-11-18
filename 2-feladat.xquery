(:
2.feladat:
Azok a könyvek, melyek 2006 után lettek kiadva, Szereplőinek száma szerint csökkenőbe rendezve, 
kiadó neve és kiadás dátuma (xs:date), szerző(i), isbn száma (mint könyv attribútuma!), 
könyv sorszáma (attribútum) és pov karaktereinek száma
:)
xquery version "3.1";

import schema default element namespace "" at "2-feladat.xsd";

let $books := fn:json-doc("data.json")?books?*

return validate { 
    document{
        <Books>
            {
                for $book at $i in $books
                    let $releaseDate := xs:date(xs:dateTime($book?released))
                    let $characterNum := fn:count(for $character in fn:distinct-values($book?characters) return $character)
                    let $povCharacterNum := fn:count(for $povCharacter in fn:distinct-values($book?povCharacters) return $povCharacter)
                    where $releaseDate > xs:date("2006-01-01")
                    order by $characterNum descending
                    return
                        <Book nr="{$i}" isbn="{$book?isbn}">
                            <title>{$book?name}</title>
                            <authors>
                                {
                                    for $author in fn:distinct-values($book?authors)
                                        return 
                                        <author>{$author}</author>
                                }
                            </authors>
                            <publisher>{$book?publisher}</publisher>
                            <releaseDate>{$releaseDate}</releaseDate>
                            <characterNum>{$characterNum}</characterNum>
                            <povCharacterNum>{$povCharacterNum}</povCharacterNum>
                        </Book>                        
             }
        </Books>
    }}