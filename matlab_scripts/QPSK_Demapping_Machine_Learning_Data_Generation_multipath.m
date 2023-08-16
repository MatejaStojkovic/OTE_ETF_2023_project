 % MATLAB skripta za generisanje podataka za Machine Learning projekat
% Podaci se generišu u niskofrekvencijskom ekvivalentu - QPSK postupak

clear all; close all; clc;

% QPSK - Korektna
PSK4 = pskmod(0:3,4,pi/4,'gray');
figure(1)
hold on
plot(real(PSK4),imag(PSK4),'ro')
grid on
title('Konstelacije QPSK signala')

% Definisanje parametara signala i sistemske u?estanosti odabiranja
Vb = 1024;      % Ekvivalentni binarni protok (infromacionog) signala
Tb = 1/Vb;      % Trajanje bita informacionog signala
Nbps = 2;       % Broj bita po simbolu
Vs = Vb/Nbps;   % M-arni protok, protok simbola
Ts = 1/Vs;      % Ts - trajanje perioda signaliziranja na liniji veze
Nsps = 32;      % Broj odbiraka po prenošenom simbolu - M-arnom simbolu
Todb = Ts/Nsps; % Trajanje odbirka
fodb = 1/Todb;  % Frekvencija odabiranja

% Ostali sistemski parametri

Nsym = 64*1024+2;       % Broj prenesenih M-arnih simbola 
Nbita = Nsym*Nbps;      % Ukupan broj prenesenih bita
Nsample = Nsym*Nsps;    % Ukupan broj odbiraka
Nfft = 4096;            % Broj ta?aka pri prora?unu DFT za procenu SGSS
Nframe = Nsample/Nfft;  % Broj prora?una DFT za procenu SGSS - broj frejmova
SimulationTime = Todb*Nsample;      % Trajanje simulacije
tosa = (0:Nsample-1)*Todb;          % Vremenska osa
fosa =  -(Nfft/2)*fodb/Nfft:fodb/Nfft:(Nfft/2-1)*fodb/Nfft;  % Frekvencijska osa

% Uobli?avanje impulsa - signaliziranje
RollOff = 0.5;          % Faktor zaobljenja ako se koristi
FilterSpan = 6;         % Dužina impulsnog odziva filtra u simbolima

rrcFilter = rcosdesign(RollOff, FilterSpan, Nsps,'sqrt');
% FIR filtar za uobli?avanje - square-root raised cosine filter

% Uticaj šuma - AWGN kanal
EbNodB = 0:3:21;         % Moguce vrednosti odnosa srednje bitske energije i SGSS šuma
NumSNR = length(EbNodB); % Broj ta?aka u kojima se meri verovatno?a greške    
SNRdB = EbNodB + 10*log10(Nbps) - 10*log10(Nsps);   
                % Vektor odnosa srednje snage signala i AWGN na ulazu u prijemnika              
Nsnr = length(SNRdB);    % Broj odnosa SNR za koji se radi analiza
argument = sqrt(10.^(EbNodB/10));                

% Greška sinhronizacije faze na prijemu
PhaseError = pi/6;    % Konstantna/Maksimalna greška sinhronizacije faze

% Multi-path kanal
MPC = [1 -0.25+1i*0.25 0.1-1i*0.1];
MPClength = 3;

% Simulacija

% Generisanje informacione sekvence - binarna sekvenca (jenakoverovatni simboli)
BinInfSeq = ((rand(Nbita,1)-0.5)>0);

% Izbor konstelacije
konstelacija = PSK4;
PebTeor = 0.5*erfc(argument);

% Modulacija - Mapiranje
BinWords = reshape(BinInfSeq,Nbps,Nsym)';
Symbols(1:Nsym,1) = bi2de(BinWords,'left-msb');
Signal(1:Nsym,1) = konstelacija(Symbols+1);

% Signali na izlazu
Labele_Kompleksni_simboli(1:Nsym,1) = Signal(1:Nsym,1);
Labele_Redni_brojevi_simbola(1:Nsym,1,1)= Symbols(1:Nsym,1)+1;
PoslatiBiti(1:2*Nsym,1,1) = BinInfSeq;
Simboli_na_prijemu_uzorak(1:Nsnr,1:Nsym) = zeros(Nsnr,Nsym);
Simboli_na_prijemu_fazni_offset_uzorak(1:Nsnr,1:Nsym) = zeros(Nsnr,Nsym);
Simboli_na_prijemu_multipath_uzorak(1:Nsnr,1:Nsym) = zeros(Nsnr,Nsym);

Detektovani_Simboli_na_prijemu_uzorak(1:Nsnr,1:Nsym) = zeros(Nsnr,Nsym);
Detektovani_Simboli_na_prijemu_fazni_offset_uzorak(1:Nsnr,1:Nsym) = zeros(Nsnr,Nsym);
Detektovani_Simboli_na_prijemu_multipath_uzorak(1:Nsnr,1:Nsym) = zeros(Nsnr,Nsym);

% Uobli?avanje

SigShaped(:,1) = upfirdn(Signal, rrcFilter, Nsps);      

for jjj = 1 : NumSNR
    
    % Dodavanje AWGN
    rxSig = awgn(SigShaped, SNRdB(jjj), 'measured');
    
    % Greška sinhronizacije faze
    PhaseErrorVector(1:length(rxSig),1) = (2*rand(1,length(rxSig))-1)*PhaseError;
    rxSigPhase = rxSig.*exp(i*PhaseErrorVector);
    clear PhaseErrorVector
      
    % Optimalno filtriranje i odabiranje
    
    % Uobli?avanje
    
    % ?ist signal
    rxRRCFiltered = 0;
    rxRRCFiltered = upfirdn(rxSig, rrcFilter, 1, Nsps);
    rxFiltered(1,1:Nsym) = rxRRCFiltered(FilterSpan+1:length(rxRRCFiltered)-FilterSpan);
    
    % Fazna greška
    rxRRCFiltered = 0;
    rxRRCFiltered = upfirdn(rxSigPhase, rrcFilter, 1, Nsps);
    rxFilteredPhase(1,1:Nsym) = rxRRCFiltered(FilterSpan+1:length(rxRRCFiltered)-FilterSpan);
    
    % Sa uticajem multi-path kanala
    finsam = length(rxSig);
    rxSig1(1:finsam-(MPClength-1)*Nsps) = rxSig(1:finsam-(MPClength-1)*Nsps);
    rxSig2(1:finsam-(MPClength-1)*Nsps) = rxSig(Nsps+1:finsam-(MPClength-2)*Nsps);
    rxSig3(1:finsam-(MPClength-1)*Nsps) = rxSig(2*Nsps+1:finsam-(MPClength-3)*Nsps);
    rxSigMP(1:finsam-(MPClength-1)*Nsps) = MPC(3)*rxSig1 + MPC(2)*rxSig2 + MPC(1)*rxSig3;            
    
    rxRRCFiltered = upfirdn(rxSigMP, rrcFilter, 1, Nsps);
    rxFilteredMP(1,1:Nsym-MPClength+1) = rxRRCFiltered(FilterSpan+1:length(rxRRCFiltered)-FilterSpan);   
    clear rxRRCFiltered
        
    Simboli_na_prijemu_uzorak(jjj,1:Nsym) = rxFiltered(1,1:Nsym);
    Simboli_na_prijemu_fazni_offset_uzorak(jjj,1:Nsym) = rxFilteredPhase(1,1:Nsym);
    Simboli_na_prijemu_multipath_uzorak(jjj,1:Nsym-MPClength+1) = rxFilteredMP(1,1:Nsym-MPClength+1);
    
    % Odlu?ivanje
    
    % ABGŠ signal
    [distance, decisions] = min(abs((ones(4,1)*rxFiltered(1,:))-(ones(Nsym,1)*konstelacija).'));
    DetectedSymbols = decisions-1;

    SymbolErrors = sum(abs(DetectedSymbols'-Symbols) > 0);
    Pes(jjj) = SymbolErrors/Nsym;        % Procena verovatno?e greške po simbolu

    BinWordsDetected = de2bi(DetectedSymbols,'left-msb');
    DetectedBits = reshape(BinWordsDetected',1,Nbita);
    
    BitErrors = sum(abs(DetectedBits'-BinInfSeq) > 0);
    Peb(jjj) = BitErrors/Nsym/Nbps;     % Procena verovatno?e greške po bitu
    
    % Greška Faze
    [distance, decisionsPhase] = min(abs((ones(4,1)*rxFilteredPhase(1,:))-(ones(Nsym,1)*konstelacija).'));
    DetectedSymbols = decisionsPhase-1;

    SymbolErrors = sum(abs(DetectedSymbols'-Symbols) > 0);
    PesPhase(jjj) = SymbolErrors/Nsym;        % Procena verovatno?e greške po simbolu

    BinWordsDetected = de2bi(DetectedSymbols,'left-msb');
    DetectedBits = reshape(BinWordsDetected',1,Nbita);
    
    BitErrors = sum(abs(DetectedBits'-BinInfSeq) > 0);
    PebPhase(jjj) = BitErrors/Nsym/Nbps;     % Procena verovatno?e greške po bitu
   
    % Sa milti-path kanalom
    [distance, decisionsMP] = min(abs((ones(4,1)*rxFilteredMP(1,:))-(ones(Nsym-MPClength+1,1)*konstelacija).'));
    DetectedSymbols = decisionsMP-1;

    SymbolErrors = sum(abs(DetectedSymbols'-Symbols(MPClength:Nsym)) > 0);
    PesMultiPath(jjj) = SymbolErrors/(Nsym-MPClength+1);        % Procena verovatno?e greške po simbolu

    BinWordsDetected = de2bi(DetectedSymbols,'left-msb');
    DetectedBits = reshape(BinWordsDetected',1,Nbita-2*(MPClength-1));
    
    BitErrors = sum(abs(DetectedBits'-BinInfSeq(2*(MPClength-1)+1:Nbita)) > 0);
    PebMultiPath(jjj) = BitErrors/(Nsym-MPClength+1)/Nbps;     % Procena verovatno?e greške po bitu
    
    Detektovani_Simboli_na_prijemu_uzorak(jjj,1:Nsym) = decisions;
    Detektovani_Simboli_na_prijemu_fazni_offset_uzorak(jjj,1:Nsym) = decisionsPhase;
    Detektovani_Simboli_na_prijemu_multipath_uzorak(jjj,1:Nsym-MPClength+1) = decisionsMP;
    clear DetectedBits SymbolErrors distance decisions decisionsPhase decisionsMP
    
end;
PesTeor = 2*PebTeor;

save DataForML Labele_Kompleksni_simboli Labele_Redni_brojevi_simbola Simboli_na_prijemu_uzorak Simboli_na_prijemu_fazni_offset_uzorak Simboli_na_prijemu_multipath_uzorak
save Data_Klasicno_odlucivanje Detektovani_Simboli_na_prijemu_uzorak Detektovani_Simboli_na_prijemu_fazni_offset_uzorak Detektovani_Simboli_na_prijemu_multipath_uzorak
save DataPesPeb PesTeor Pes PesPhase PesMultiPath PebTeor PebPhase PebMultiPath 