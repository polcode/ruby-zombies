# Aplikacje, Ruby oraz Zombie!

## 1. Intro

Często zapominamy o tym, że Ruby nie kończy się na Railsach. Jednym z mniej oczywistych zastosowań Ruby’ego jest tworzenie aplikacji desktopowych, a więc zapoznajmy się nieco z tym tematem w sposób być może trochę niekonwencjonalny - pokonując hordę głodnych zombie!

### 1.1. Ale jak to, Ruby bez Railsów?

Niestety, chociaż Ruby jest fajnym językiem programowania, większość osób ogranicza się w kontakcie z nim do Railsów, ewentualnie jakichś drobnych skryptów konsolowych, natomiast tworzenie aplikacji desktopowych oraz mobilnych (przez co, jak zapewne domyśleliście się po tytule prezentacji, rozumiem także i gry) to jedno z mniej oczywistych, a nadal całkowicie poprawnych zastosowań tego języka. 

Mamy więc na przykład RubyMotion, które pozwala na przygotowanie aplikacji mobilnych dla iOSa oraz Androida. Możemy także przygotować dystrybuowalne paczki zawierające nasz kod oraz biblioteki potrzebne do jego działania (gemy oraz interpreter Ruby) za pomocą jednego z narzędzi typu Ocra (https://github.com/larsch/ocra - aplikacje Windowsowe) czy Releasy (https://github.com/sveinbjornt/Platypus - OS X). 

Zanim jednak zaczniemy cokolwiek pakować i dystrybuować, trzeba najpierw mieć co, tak więc przejdźmy dalej.

### 1.2. Libgosu

Jest dostępnych sporo bibliotek wspomagających tworzenie aplikacji, ale ja skupię się dzisiaj na jednej z nich, czyli libgosu. Biblioteka ta daje nam dostęp do rzeczy potrzebnych przy tworzeniu gier, czyli wyświetlania grafiki 2D, dźwięków, obsługi myszy i klawiatury oraz podstawowej pętli aplikacji.

## 2. Hello World

Zacznijmy od tego, od czego zaczyna każdy programista, czyli od wyświetlenia Hello World na ekranie. 

### 2.1. Okienko

Mamy więc tutaj 10 linijek kodu - ładujemy naszą bibliotekę, deklarujemy okienko (dziedziczące po Gosu::Window), i w initializerze naszej klasy robimy dwie rzeczy - wywołujemy super z rozmiarami okienka oraz ustalamy nazwę, jaką ma mieć to okienko.

Na koniec uruchamiamy nasz kod i gotowe.

### 2.2. Obsługa klawiatury

Dodajmy możliwość wyjścia z naszej aplikacji. Posłuży nam do tego metoda button_down, która otrzymuje id wciśnietego klawisza (albo przycisku na myszy czy gamepadzie). Jeśli wcisnęliśmy escape - zamykamy okienko. Jeśli wciśniemy cokolwiek innego, odtworzymy zadeklarowany wcześniej plik wave.

### 2.3. Tekst w okienku

Ale co to za hello world bez właściwego napisu, prawda? No to do dzieła. Deklarujemy zmienną @message, która jest tak naprawdę obrazkiem wygenerowanym z danego tekstu (w ten sposób wygenerowaliśmy obrazek raz i możemy go wyświetlić dużo szybciej i wydajniej jako teksturę na ekranie), oraz dodajemy metodę draw, która rysuje nam tenże obrazek na środku ekranu.

### 2.4. Animacja

Kolejny krok to animacja. Deklarujemy metodę update, która będzie aktualizować nam położenie naszego obrazka na podstawie aktualnego czasu i odrobiny matematyki. Oczywiście metoda draw musi wtedy przyjąć to wyliczone położenie.

Te wszystkie przykłady razem wzięte dają nam coś takiego, co nazywa się pętlą gry. Mamy obsługę wejścia, aktualizację i rysowanie - to wszystko jest odpalane przez Gosu 60 razy na sekundę i pozwala użytkownikowi na interakcję z naszą grą. Jest to jeden z najbardziej podstawowych konceptów w programowaniu gier i taka pętla jest podstawą każdego silnika gry.

## 3. RubyZombies

Ponieważ jednak latający napis Hello World to bardzo słaba gra, napiszmy coś nieco bardziej zaawansowanego, co przy okazji pozwoli nam poznać kilka innych podstawowych pojęć i technik.

### 3.1. Sterowanie

Na początek rozbudujemy nieco strukturę naszej gry, tak żeby nie trzymać wszystkiego w jednym pliku, a raczej w dość sensownej strukturze katalogów. Plik main.rb będzie nam odpowiadał za załadowanie wszystkich plików ruby z podkatalogów (żebyśmy nie musieli się przejmować, że zapomnimy o którymś), a także uruchomienie naszego okienka z grą.

Drugą rzeczą, która jest tutaj nowością, jest klasa GameState. Każdy z dwóch stanów to singleton, który odpowiada za implementację różnych części gry, co pozwoli nam na użycie tylu różnych pętli gry, ile będzie nam potrzebne, a jednocześnie będzie to wszystko nadal logicznie poukładane. Korzystać będziemy tutaj z dwóch - MenuState, który odpowiada za pauzę oraz ekran początkowy; oraz PlayState, który jest naszą właściwą grą. Oczywiscie, jako że są to singletony, możemy je zamieniać ze sobą, a stan naszej gry pozostanie niezmieniony, np. po odpauzowaniu.

Klasa Player odpowiada za wyświetlanie i obsługę naszej postaci. 

W initializerze pojawiła się nowa rzecz, czyli ładowanie sprite'ów. Sprite'y to (podobnie jak w cssie) obrazek z przezroczystością i różnymi klatkami animacji. Tutaj mamy także towarzyszący mu plik json, ponieważ nasz sprite został spakowany, żeby zajmował mniej miejsca. 

Metoda draw_crosshair odpowiada za wyświetlenie kursora. 

Metoda draw wyświetla nam naszego zadeklarowanego sprite'a w wyliczonej pozycji na ekranie oraz pod wyliczonym kątem.

Najwięcej dzieje się w metodzie update. 

Na początek wyliczamy kąt obrócenia naszego sprite'a za pomocą Utils.get_angle - jest to prosta metoda, która tak naprawdę sprowadza się do wywołania atan2 (atan to arcus tangens, a czemu 2? bo ta funkcja przyjmuje dwa parametry) i zamienienia wyniku z radianów na stopnie. Dzięki temu nasza postać kieruje się w stronę kursora myszy.

Następnie sprawdzamy, które przyciski gracz wcisnął, po czym używamy Trygonometrii! żeby dowiedzieć się, o ile powinniśmy przesunąć naszego sprite'a, żeby uzyskać pożądany przez nas efekt - czyli sterowanie WSAD, gdzie W będzie ruszało naszą postacią w stronę kursora myszy, S w tył, a A i D odpowiednio na boki.

Na koniec mamy PlayState, gdzie inicjalizujemy, wyświetlamy i aktualizujemy naszą postać.

### 3.2. Teren

Chodzenie postacią po czarnym tle jest nudne, dajmy więc naszemu bohaterowi jakiś teren do poruszania się. Przygotowałem prostą planszę w edytorze Tiled - mamy ją zapisaną w media w postaci pliku json, oraz używany tilesheet, czyli po prostu zestaw różnych kafelków, z których składamy naszą grafikę. To kolejna podstawa programowania gier - pozwala to na proste i szybkie tworzenie poziomów, kafelki można oczywiście wykorzystywać wielokrotnie, a przeczytanie i obrobienie pliku json to przecież nie problem, tym bardziej że mamy od tego odpowiedniego gema. :)

Mamy więc nową klasę Map, która odpowiada za rysowanie naszego terenu. W initializerze klasy ładujemy odpowiedni plik, a w draw rysujemy jej odpowiedni kawałek, bo cała mapa jest większa niż rozmiar naszego okienka.

Kolejne dwie metody naszej klasy sprawdzają, czy dane koordynaty x, y są nadal na mapie (żeby nie wychodzić za jej krawędzie), oraz czy przez dany kafelek można przejść - nasz json zawiera 2 warstwy kafelków, gdzie jedna warstwa to podłoga/ziemia, a druga to ściany i drzewka. Jeśli na tej drugiej warstwie jest kafelek, to nie możemy tam wejść i tyle.

Żeby to wszystko działało, zmieniłem nieco klasę Player. 

Główną różnicą jest rozbicie koordynatów x i y postaci na dwa zestawy - x, y oraz screen_x, screen_y. Wersja screen_ jest ustawiona na sztywno na środek ekranu, a koordynaty x i y to miejsce naszej postaci w świecie gry. Koordynaty 0, 0 to lewy górny róg załadowanej przez nas mapy.

Drugim ważnym elementem jest metoda viewport, która definiuje nam prostokąt o rozmiarach okienka gry, który jest ustawiony tak, że x i y gracza w świecie gry są na środku tego okienka. Tak naprawdę metoda viewport zwraca nam tylko koordynaty lewego górnego rogu tego prostokąta, bo więcej nie jest nam do niczego potrzebne.

Metoda update została nieco uproszczona, wyrzucając powtarzalne obliczenia do zewnętrznej funkcji i poruszając postać tylko wtedy, gdy jest to nam potrzebne i gdy nowe wyliczone koordynaty nie powodują kolizji z terenem.

PlayState nie zmienił się zbytnio - przekazujemy dla naszej postaci koordynaty w świecie i mapę, oraz rysujemy wybrany kawałek mapy na podstawie wyliczonego viewportu.

### 3.3. Wrogowie

Miały być zombie, no to w końcu nadszedł czas na zombie. Najpierw jednak trochę refaktoringu, żeby było łatwiej. 

Kursor, nazwa okienka oraz viewport wylatują do osobnej klasy Interface. Klasa GameObject będzie podstawą dla naszego bohatera i zombie, a nowa klasa ObjectPool posłuży nam jako odnośnik do wszystkich wygenerowanych przez nas obiektów oraz mapy, zeby było łatwiej zaprogramować interakcje pomiędzy nimi.

Delikatnie zmieniła się klasa Player - oprócz zmian wynikacjących z refaktoringu, wprowadziłem tam drugiego sprite'a, który jest używany podczas poruszania się postaci. 

Nowością jest klasa Zombie. Ich metoda update jest podobna do metody w klasie Player, z tym że zombie na początku stoją w miejscu, a gdy gracz zbliży się do nich na odległość mniejszą niż 300 pikseli, wtedy nasze zombie zaczyna iść w stronę gracza, wykorzystując znane nam już z pierwszego przykładu funkcje get_movement i get_angle.

Na koniec drobne zmiany w PlayState - generujemy odpowiednią ilość zombie w losowych miejscach na mapie, odrzucając wyniki które trafiły w kafelek, przez który nie można przejść.

### 3.4. Kolizje obiektów



## 4. Na zakończenie

Oczywiście z racji ograniczonej ilości czasu, nasza gra musi pozostać w dość prostej formie, ale to jeszcze nie wszystko.

### 4.1. Podsumowanie

Przez ostatnią godzinę poznaliście trochę podstaw programowania gier, które tak naprawdę są niezmienne i wykorzystywane w praktycznie każdym silniku gier. Podsumujmy:

* Pętla gry - input, update, draw
* Trochę matematyki - kąt pomiędzy dwoma punktami, odległość pomiędzy dwoma punktami, podstawy trygonometrii :)
* Wyświetlanie sprite'ów oraz terenu złożonego z kafelków
* Podstawowe kolizje pomiędzy obiektami

### 4.2. Co dalej?

Można oczywiście dalej rozwijać naszą małą grę, dodając kolejne funkcjonalności, ale niestety to już temat na całkiem grubą książkę, a nie godzinną prezentację :)

* testy rspeca - tak, można testować takie rzeczy w rspecu
* interfejs użytkownika - życie, punkty
* lepsza grafika - animacje, bardziej urozmaicone poziomy
* multiplayer - istnieją biblioteki Ruby które to w dużym stopniu ułatwiają
* bardziej rozbudowany gameplay - różne bronie, różne poziomy itp
* co kto jeszcze sobie wymyśli

### 4.3 Przydatne linki

* Kod prezentacji - https://github.com/polcode/ruby-zombies
* Gosu - https://www.libgosu.org
* Shoebox - http://renderhjs.net/shoebox/
* Tiled - http://www.mapeditor.org
* Grafika - http://www.kenney.nl
* Książka - https://leanpub.com/developing-games-with-ruby/