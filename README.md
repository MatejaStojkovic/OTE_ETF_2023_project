# OTE_ETF_2023_project

## Uvod

### QPSK Modulacija

### Naivni Bayesov klasifikator

Ideja je iskoristiti Bayesov teorem za klasifikaciju. Bayesov teorem je dat sa:
$ovde ide teorema$.
Možemo da primetimo da će donji član biti isti za sve simbole pa nam on nije značajan za računanje.
Kako bi smo našli $P(x|y)$, potrebno je da aproksimiramo raspodelu verovatnoća $P(x|y)$.
Kako znamo da nam je kanal AWGN, to znači da će $P(x|y)$ biti normalna raspodela.
Iz našeg trening skupa možemo da izračunamo parametre normalne raspodele, tj. $\mu$ i $\sigma$.
<!-- I onda ovde jos malo formula i preformulisati lol  -->

### Support Vector Machine (SVM)

Osnovna ideja SVM-a (Support Vector Machine) je da se nađe hiper-ravan koja najbolje razdvaja podatke u prostoru. Za QPSK imamo 4 simbola, pa je potrebno imati 2 klasifikatora koje klasifikuju podatke, jedan klasifikator za komponentu u fazi (I) i komponentu u kvadraturi (Q). Posto SVM moze koristiti razlicite matematicke funkcije (kernele) kako bi transformisao podate, mi smo koristili linearni kernel, jer je on sasvim dovoljan za posao koji radimo i daje dobre rezultate. Kada se pronadju parametri koji najbolje razdvajaju podatke, oni se onda koriste za klasifikaciju novih podataka.



## Metod

U prvom eksperimentu koristimo 8 različitih SNR vrednosti. Za trening podatke imamo $8x20000$ podataka dok za test podatke imamo $8x25000$.

U drugom eksperimentu koristimo 4 različite SNR vrednosti. Za trening podatke imamo $4x20000$ podataka dok za test podatke imamo $4x25000$.

U trećem eksperimentu imamo podatke sa multipath kanala. 
<!-- Treba sad opisati kako se generišu multipath kanali i šta je različito -->
## Rezultati

<!-- Fale podaci o klasicnim metodama -->
Posmatraćemo rezultate za tri metode: Naivni Bayesov klasifikator, SVM i klasične metode.
Mozemo primetiti da su rezultati za SVM i Naivni Bayesov klasifikator slični, dok su rezultati za klasične metode malo lošiji. Po nasem mišljenju, upotreba SVM-a i Naivnog Bayesovog klasifikatora nije opravdana, jer ne daju dovoljno dobre rezultate u odnosu na klasične metode.

### Rezulati sa svi SNR vrednostima

<!-- I onda ovde samo devet plotova u jednom plotu po jedna heat mapa za SVM, NB i klasicnu metodu -->

### Rezultati sa pola SNR vrednosti

<!-- Ovde samo 5 plotova u jednom plotu po jedna heat mapa za SVM, NB i klasicnu metodu -->

### Multipath rezultati

TODO;

<!-- Ovde samo jedan plot sa 3 heat mape za SVM, NB i klasicnu metodu -->

## Zaključak

Kako je problem jednostavan, metode ML iako daju slične(ili malo bolje) rezultate od klasičnih metoda, ne daju dovoljno dobre rezultate da bi se koristile u praksi. Ovo se moze objasniti time sto je problem jednostavan i klasične metode su dovoljne da se reše problemi. Takodje, SVM i Naivni Bayesov klasifikator su dosta kompleksniji od klasičnih metoda, pa je njihova upotreba neopravdana.

## TODO
Mateja:
- slika podataka
- istrenirati svm i naive bayas nad faznim kasnjenjima
Drakula:
- istrenirati mrezu nad multipathom bez prethodnih vrednosti
- isrenirati multipath sa lin reg 
- probati nad regresijom promeniti naivni bayes