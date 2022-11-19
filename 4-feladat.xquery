(:
4.feladat:
XML
TV Sorozatokat csoportosítjuk évadok szerint.
Attribútumként megjelenik az összes évad száma,
Ezt követően az évadok külön külön elemekbe, attribútumok: évad sorszáma, karaktereinek száma,
Évadon belül az odatartozó karakterek adatai: név(attribútumként), milyen ház(akba) tartozik, nem, kultúra
:)

xquery version "3.1";

import schema default element namespace "" at "4-feladat.xsd";

let $houses := fn:json-doc("data.json")?houses?*
let $characters := fn:json-doc("data.json")?characters?*
let $tvSeriesCount := fn:count(for $character in $characters
                for $tvSerie in fn:distinct-values($character?tvSeries)
                where $tvSerie ne ""
                group by $tvSerie
                return $tvSerie
                )

return validate { 
    document {
        <TvSeries seasons="{$tvSeriesCount}">
        {
            for $character in $characters
                for $season in fn:distinct-values($character?tvSeries)
                where $season ne ""
                group by $season
                let $characterCount := fn:count(
                    for $character in $characters
                                where fn:exists(index-of($character?tvSeries, $season))
                                return $character
                )
                return 
                    <Season nr="{fn:tokenize($season)[2]}" characterCount="{$characterCount}">
                        {
                            for $character in $characters
                                where fn:exists(index-of($character?tvSeries, $season))
                                return 
                                <Character name="{$character?name}">
                                    <Allegiances>
                                        {
                                            for $allegiance in fn:distinct-values($character?allegiances)
                                                return
                                                <House>{$houses[?url = $allegiance]?name}</House>
                                        }
                                    </Allegiances>
                                    <Gender>{$character?gender}</Gender>
                                    <Culture>{$character?culture}</Culture>
                                </Character>
                        }
                    </Season>
        }
        </TvSeries>
    } }