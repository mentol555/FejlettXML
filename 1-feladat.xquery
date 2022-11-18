(:
1.feladat:
Azon névvel és férjjel rendelkező nők száma, akik megszülettek valamikor,
Valamint, ezen nők adatai: Nevük, Nemük, Férjük neve, Születésük és elhalálozásuk (ha meghaltak már!),
Számuk (a karakter sorszáma, attribútumként)
Csak azokat a feleségeket keressük ezek közül, melyek nevei A vagy B-vel kezdődnek.
:)
xquery version "3.1";

import schema default element namespace "" at "1-feladat.xsd";

let $characters := fn:json-doc("data.json")?characters?*

return validate{
    document{
        <Wives>
            <Count>
            {
                fn:count(
                    for $wife in $characters
                        where $wife?name and $wife?spouse and $wife?born and $wife?gender = "Female" and
                            fn:matches($wife?name, "^(A|B)")
                        return $wife
                )
            }
            </Count>
            {
                for $character at $i in $characters
                    let $wife := $character
                    where $wife?name and $wife?spouse and $wife?born and $wife?gender = "Female" and
                            fn:matches($wife?name, "^(A|B)")
                    order by $wife?name
                    return
                        <Wife nr="{$i}">
                            <name>{$wife?name}</name>
                            <gender>{$wife?gender}</gender>
                            <spouse>
                                {
                                    $characters[?url = $wife?spouse]?name
                                }
                            </spouse>
                            <born>{$wife?born}</born>
                            {
                            if($wife?died)
                               then <died>{$wife?died}</died>
                               else ()   
                            }
                        </Wife>                        
             }
        </Wives>
    }}