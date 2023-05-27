%Studio del sistema motore elettrico in catena aperta

J=0.01; b=0.1; K=0.01; R=1; L=0.5;
num=K;
den=[(J*L) ((J*R)+(L*b)) ((b*R)+K^2)];
motor=tf(num,den); % Funzione di trasferimento tra l’ingresso v(t) e l’uscita


% Risposta ad impulso unitario

impulse(motor,0:0.1:4); %disegno la risposta al gradino

% Risposta a gradino unitario

step(motor,0:0.1:4); %disegno la risposta al gradino

%Risposta alla rampa

t = 0:0.1:10; %dominio del tempo valido
u = (t); %funzione d'ingresso
lsim(motor,u,t); %risposta della funz di trasf nel dominio del tempo all'ingresso

%Risposta alla sinusoide

t = 0:0.1:20; %dominio del tempo valido
u = cos (t); %funzione d'ingresso
lsim(motor,u,t); %risposta della funz di trasf nel dominio del tempo all'ingresso


%C(s) con Rete anticipatrice

Zo = 1; %zero in 1
Po = 100; %polo in 0.1
contr = 1000*tf([Zo 1],[Po 1]); %funz di trasf controllore
bode(contr*motor); %disegno Bode sistema
margin(contr*motor); %evidenzia margine di fase e pulsazione di attraversamento


% come si comporta il sistema a catena chiusa quando viene sollecitato con un gradino unitario in ingresso.
sys_cl=feedback(contr*motor,1); %funzione di trsferimento in catena chiusa
t=0:0.01:10; %vettore tempo nel quale vado ad analizzare il segnale
step(sys_cl,t) %grafico dell’uscita

%controllore P
kp_vett=[ 0.1, 1, 10, 72, 100, 200, 500, 1000 ]; %imposto valori di Kp
figure(1)
for n=1:length(kp_vett)
kp=kp_vett(n); %imposto valore corrente di Kp
sys=feedback(kp*motor,1); %retroazione del sistema per il contr
step(sys,0:0.001:2) %disegno grafico
hold on
legend('0.1', '1', '10', '72', '100', '200', '500', '1000');
Title('Risposta a gradino per i diversi valori di Kp');
end

%CONTROLLO PD

kp_vett=[ 0.1, 1, 10, 72, 100, 1000]; %valori di Kp
kd_vett=[ 0.1, 1, 10, 100, 1000]; %valori di Kd
for n=1:length(kp_vett) %ciclo for per Kp
figure(1)
subplot(3,2,n)
kp=kp_vett(n); %imposto il valore di Kp
for m=1:length(kd_vett) %ciclo for per Kd
 kd=kd_vett(m); %imposto valore per Kd
 contr=tf([kd kp],1) %scrivo il controllore PD
 sys=feedback(contr*motor,1); %retroazione del sistema per il contr
 step(sys,0:0.001:2) %disegno grafico
 hold on
end
s=strcat('Kd variabile e Kp=', num2str(kp_vett(n)));
title(s);
end

%CONTROLLO PID 1

kd=10;
kp=110;
kivect=[ 0.1, 1, 10, 100, 200, 500, 1000 ]; %imposto valori di Ki
figure(1)
for n=1:length(kivect) %ciclo per Ki
ki=kivect(n); %imposto valore corrente di Ki
contr=tf([kd kp ki],[1 0]); %funz di trasf controllore
sys=feedback(contr*motor,1); %retroazione del sistema per il contr
step(sys,0:0.001:2) %disegno grafico
hold on
legend('0.1', '1', '10', '100', '200', '500', '1000');
Title('Risposta a diversi valori di Ki');
end

%CONTROLLO PID 2

kd=10;
kp=100;
ki_vett=[180, 190, 200, 210, 220 ]; %imposto valori di Ki
figure(2)
for n=1:length(ki_vett) %ciclo per Ki
ki=ki_vett(n); %imposto valore corrente di Ki
contr=tf([kd kp ki],[1 0]); %funz di trasf controllore
sys=feedback(contr*motor,1); %retroazione del sistema per il contr
step(sys,0:0.001:2) %disegno grafico
hold on
legend('180', '190', '200', '210', '220');
Title('Risposta a diversi valori di Ki');
end
