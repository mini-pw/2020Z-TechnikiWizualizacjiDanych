# Komentarz

W swojej aplikacji badam możliwość wystąpienia znajomości za pośrednictwem Facebooka między losowymi studentami z uniwersytetu Yale. Facebook w pierwszych latach istnienia był przeznaczony tylko dla studentów różnych uczelni amerykańskich (m.in. Stanford, Harvard, MIT), których sieci są udokumentowane właśnie na networkrepository.com (i przedyskutowane w artykułach zalinkowanych w komentarzu na górze kodu). W aplikacji możliwe jest zaobserwowanie, na ile dobrze mogą znać się losowo wybrani użytkownicy z jednej studenckiej społeczności.

Dla wskazanej liczby _x_ na sliderInpucie pokazuje się podgraf indukowany w całej sieci przez zbiór _x_ losowych wierzchołków.

Kolor wierzchołka oznacza jego stopień. Szary wierzchołek nie ma krawędzi w podgrafie; wierzchołek na niebiesko ("\#0000cc") ma jedną krawędź, a wierzchołek na czerwono ("\#cc0000") maksymalną występującą\*. Kolory dla pośrednich stopni są generowane poprzez funkcję R-ową _rainbow_.

\*Wyjątkiem jest sytuacja, gdy maksymalny stopień spośród wszystkich wierzchołków równa się jeden - wówczas wierzchołki o jednej krawędzi są na zielono ("\#00cc00").