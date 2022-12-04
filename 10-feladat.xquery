(:
10.feladat
HTML
Táblázat készítés
Csoportosítunk évadok szerint, így a táblázatunknak 7 sora lesz.
Első sor: oszlopnevek
Minden sorba az adott évad jelenik meg, az évad szereplőinek száma, a 3 leggyakoribb kultúra a szereplők körében(zárójelben, hogy hány tartozik oda),
a férfi szereplők száma, a női karakterek száma, valamint a leggyakoribb ház(zárójelben, hogy hány tartozik oda)
:)
xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "html";
declare option output:html-version "5.0";
declare option output:indent "yes";


let $characters := fn:json-doc("data.json")?characters?*
let $books := fn:json-doc("data.json")?books?*
let $houses := fn:json-doc("data.json")?houses?*

return document {
    <html>
        <head>
            <title>Évadok</title>
            <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css"/>
            <style>
                tr, th {{
                    text-align: center;
                    cursor: pointer;
                }}
            </style>
        </head>
        <body>
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Évad</th>
                    <th>Szereplők száma</th>
                    <th>Leggyakoribb kultúrák</th>
                    <th>Férfiak száma</th>
                    <th>Nők száma</th>
                    <th>Leggyakoribb ház</th>
                </tr>
            </thead>
            <tbody>
                {
                    for $character in $characters
                        for $season in fn:distinct-values($character?tvSeries)
                        where $season ne ""
                        group by $season
                        return 
                            <tr>
                                <td>{$season}</td>
                                <td>
                                {
                                    fn:count(
                                        for $character in $characters
                                            where fn:exists(index-of($character?tvSeries, $season)) and array:size($character?allegiances) ne 0
                                            return $character
                                    )
                                }
                                </td>
                                
                                <td>
                                {
                                    (for $character in $characters
                                        let $culture := $character?culture
                                        where fn:exists(index-of($character?tvSeries, $season)) and $culture ne ""
                                        group by $culture
                                        let $countByCulture := fn:count($character)
                                        order by $countByCulture descending
                                        return fn:concat($culture, "(",$countByCulture,")")
                                     )[position() <= 3]
                                }
                                </td>
                                <td>
                                {
                                    fn:count(
                                        for $character in $characters
                                            let $gender := $character?gender
                                            where fn:exists(index-of($character?tvSeries, $season)) and $gender = "Male"
                                            return $character
                                    )
                                }
                                </td>
                                <td>
                                {
                                    fn:count(
                                        for $character in $characters
                                            let $gender := $character?gender
                                            where fn:exists(index-of($character?tvSeries, $season)) and $gender = "Female"
                                            return $character
                                    )
                                }
                                </td>
                                <td>
                                {
                                    (for $house in $houses
                                        let $houseName := $house?name
                                        
                                        
                                        let $characterCount := fn:count(
                                            for $member in fn:distinct-values($house?swornMembers)
                                                let $character := $characters[?url = $member]
                                                where fn:exists(index-of($character?tvSeries, $season))
                                                return $member
                                        )
                                        order by $characterCount descending
                                        return fn:concat($houseName,"(",$characterCount,")")
                                     )[position() <= 1]
                                }
                                </td>
                            </tr>
                }
            </tbody>
            </table>
    </body>
    </html>
}
