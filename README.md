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


### Support Vector Machine

## Metod

U prvom eksperimentu koristimo 8 različitih SNR vrednosti. Za trening podatke imamo $8x20000$ podataka dok za test podatke imamo $8x25000$.

U drugom eksperimentu koristimo 4 različite SNR vrednosti. Za trening podatke imamo $4x20000$ podataka dok za test podatke imamo $4x25000$.

U trećem eksperimentu imamo podatke sa multipath kanala. 
<!-- Treba sad opisati kako se generišu multipath kanali i šta je različito -->
## Rezultati

<!-- Fale podaci o klasicnim metodama -->

### Rezulati sa svi SNR vrednostima

<!-- I onda ovde samo devet plotova u jednom plotu po jedna heat mapa za SVM, NB i klasicnu metodu -->

### Rezultati sa pola SNR vrednosti

### Multipath rezultati

## Zaključak

Kako je problem jednostavan metode ML iako daju slicne(ili malo bolje) rezultate od klasicnih metoda, ne daju dovoljno dobre rezultate da bi se koristile u praksi.