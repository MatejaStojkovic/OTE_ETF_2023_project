# OTE_ETF_2023_project

## Uvod
### Naivni Bayesov klasifikator

Ideja je iskoristiti Bayesov teorem za klasifikaciju. Bayesov teorem je dat sa:
$$P(A|B)=\frac{P(B|A)P(A)}{P(B)}.$$
Možemo da primetimo da će donji član biti isti za sve simbole pa nam on nije značajan za računanje.
Gde je $A$ događaj za koji želimo da znamo koja je verovatnoća da se desi ukoliko znamo da se desio događaj $B$.

Ovu formulu prilagođavamo QPSK klasifikaciji tako što su mogući događaji:
$S\in\left\{S_1, S_2, S_3, S_4\right\}$
<!-- I onda ovde jos malo formula i preformulisati lol  -->

### Support Vector Machine (SVM)

Osnovna ideja SVM-a (Support Vector Machine) je da se nađe hiper-ravan koja najbolje razdvaja podatke u
prostoru. Za QPSK imamo 4 simbola, pa je potrebno imati 2 klasifikatora koje klasifikuju podatke, jedan klasifi-
kator za komponentu u fazi (I) i komponentu u kvadraturi (Q). Posto SVM moze koristiti razlicite matematicke
funkcije (kernele) kako bi transformisao podate, mi smo koristili linearni kernel, jer je on sasvim dovoljan za
posao koji radimo i daje dobre rezultate. Kada se pronadju parametri koji najbolje razdvajaju podatke, oni se
onda koriste za klasifikaciju novih podataka

### Linear Regression

Ideja iza korišćenja Linearne regresije jeste da podatke koji imaju neku korelaciju, znatno bolje klasifikujemo nego što bi to uradili koristeći SVM ili Naivni Bayesov klasifikator. Takođe korišćenjem linearne regresije možemo da procenimo parametre multipath kanala. To jest koliko će koji simbol uticati na detektovani simbol.

## Metod

U prvom eksperimentu koristimo 8 različitih SNR vrednosti. Za trening podatke imamo $8x20000$ podataka dok za test podatke imamo $8x25000$.

U drugom eksperimentu koristimo 4 različite SNR vrednosti. Za trening podatke imamo $4x20000$ podataka dok za test podatke imamo $4x25000$.

U trećem eksperimentu imamo podatke sa multipath kanala. 
<!-- Treba sad opisati kako se generišu multipath kanali i šta je različito -->
## Rezultati

<!-- Fale podaci o klasicnim metodama -->
Posmatraćemo rezultate za tri metode: Naivni Bayesov klasifikator, SVM i klasične metode. Mozemo prime-
titi da su rezultati za SVM i Naivni Bayesov klasifikator slični, dok su rezultati za klasične metode malo lošiji.
Po nasem mišljenju, upotreba SVM-a i Naivnog Bayesovog klasifikatora nije opravdana, jer ne daju dovoljno
dobre rezultate u odnosu na klasične metode.



<!-- Ovde samo 5 plotova u jednom plotu po jedna heat mapa za SVM, NB i klasicnu metodu -->

<!-- Ovde samo jedan plot sa 3 heat mape za SVM, NB i klasicnu metodu -->

## Zaključak

Nad običnim podacima klasičan klasifikator već postiže jako dobre rezultate i kako je gausov šum potpuno nekorelisan SVM i NB ne mogu da postigunu bolje rezulate od klasičnih metoda.
U slučaju kanala sa faznom greškom, kako je fazna greška bila relativno mala, klasičan klasifikator idalje je davao skoro savršene rezultate pa nije mogla da se vidi velika razlika umesto metoda SVM i NB.
Na primeru multipath kanal možemo da vidimo najveći potencijal modela za mašinsko učenje. Jer linearna regresija može za nas da zaključi parametre sistema koje bi usuprotnom teško mogli da zaključimo ili izmerimo.