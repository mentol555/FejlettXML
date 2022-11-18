(:
3.feladat:
A házakat régiók szerint csoportosítjuk, és név szerint rendezzük.
A régiók száma attribútumként jelenik meg.
A régió neve, és odatartozó házak száma attribútumként jelenik meg
A ház neve attribútumaként jelenik meg az adott háznak.
A házak adatait jelenítjük meg: founder, currentLord, swornMembersCount, words
:)
xquery version "3.1";

import schema default element namespace "" at "3-feladat.xsd";

let $houses := fn:json-doc("data.json")?houses?*
let $characters := fn:json-doc("data.json")?characters?*
let $regionCount := fn:count(for $house in $houses
                        let $region := $house?region
                        group by $region
                        return $region)

return 
    document{
        validate {
        <Houses regions="{$regionCount}">
            {
            for $house in $houses
                let $region := $house?region
                group by $region
                order by $region
                let $count := fn:count($house)
                return
                <Region name="{$region}" houses="{$count}">
                    {
                    for $house in $houses
                        where $house?region eq $region
                        return 
                            <House name="{$house?name}">
                                <Founder>
                                    {$characters[?url = $house?founder]?name}
                                </Founder>
                                <CurrentLord>
                                    {$characters[?url = $house?currentLord]?name}
                                </CurrentLord>
                                <SwornMembersCount>
                                    {
                                        fn:count(
                                            for $sworn in fn:distinct-values($house?swornMembers)
                                                return $sworn
                                        )
                                    }
                                </SwornMembersCount>
                                <Words>{$house?words}</Words>
                            </House>
                    }
                </Region>
            }
        </Houses>
        }
        }