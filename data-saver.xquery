(:
Feladat:
Adatok kinyerése az API-ból, és ezen adatok lokális lementése egy json formátumú állományba.
:)
xquery version "3.1";

declare namespace array = "http://www.w3.org/2005/xpath-functions/array";
declare namespace map = "http://www.w3.org/2005/xpath-functions/map";
declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "json";
declare option output:indent "yes";

declare variable $charactersApi := "https://anapioficeandfire.com/api/characters?pageSize=50&#38;page=";
declare variable $housesApi := "https://anapioficeandfire.com/api/houses?pageSize=50&#38;page=";
declare variable $booksApi := "https://anapioficeandfire.com/api/books?pageSize=50&#38;page=";

declare variable $charactersPageNum := 43;
declare variable $housesPageNum := 9;
declare variable $booksPageNum := 1;

declare variable $results := [];

declare function local:get-all-data($uri, $i, $pageNum)
{
    let $page := json-doc(fn:concat($uri, $i))
    return if ($i = $pageNum + 1) then $results else array:join(($page, local:get-all-data($uri, $i+1, $pageNum)))
};

map{
    "characters": local:get-all-data($charactersApi, 1, $charactersPageNum),
    "houses": local:get-all-data($housesApi, 1, $housesPageNum),
    "books": local:get-all-data($booksApi, 1, $booksPageNum)
}