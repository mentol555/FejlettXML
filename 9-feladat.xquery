(:
9.feladat
JSON
Azokat a szereplőket keressük, akik nem tartoznak egy házhoz sem. (allegiances [])
Ezek közül azokat válogassuk ki, akik szerepeltek az 5-ös számú könyvben, valamint a sorozat 3. és/vagy 6. évadjában.
Ezeket a karaktereket csoportosítsuk nemük szerint, és a csoportokban szerepeljen az odatartozó karakterek száma? 
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

map {
    "Characters": array {
    
    }
}