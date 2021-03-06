function [zI,zQ,A,tau] = receiver(y)
fs = 400000;
seconds = length(y)/fs;
B = 10000;
int = [125000 145000];
t = linspace(0,seconds,fs*seconds);
N = 500;

%filter"s
[bbp,abp] = fir1(N,((int)./(fs/2)));
[blp,alp] = fir1(N,B/(fs/2));

%Retrive signal from our carrier frequency
s = filter(bbp,abp,y);
s = s((N/2)+1:end);
s = [s; zeros((N/2),1)];

%Demodulate
ts = 2*pi.*135000.*t;
zI_t = s.*2.*cos(ts');
zI_t = filter(blp,alp,zI_t);
zI_t = zI_t((N/2)+1:end);
zI_t = [zI_t; zeros((N/2),1)];

zQ_t = s.*-2.*sin(ts');
zQ_t = filter(blp,alp,zQ_t);
zQ_t = zQ_t((N/2)+1:end);  
zQ_t = [zQ_t; zeros((N/2),1)];

%calculate cross corellation between chirp and recived chirp.
tc = linspace(0,1,fs);
cc = [zeros(2000000,1) ; chirp(tc,0,1,200)' ; zeros(10000,1) ];

[qI,lagI] = xcorr(zI_t,cc);
[qQ,lagQ] = xcorr(zQ_t,cc);

[auto,lag] = xcorr(cc,cc);

%figure;
%plot(lagQ/fs,qQ)
%title('Autokorrelation av en chrirpsignal')
%xlabel('\lambda (sekunder)')
%ylabel('r_{c}(\lambda)')
plot_sig(lagI,qI,fs)


II = find(abs(qI)==max(abs(qI)));
IQ = find(abs(qQ)==max(abs(qQ)));

%Calculate Tau
if qI(II) > qQ(IQ)
   tau = lagI(II)/fs;
else
   tau = lagQ(IQ)/fs;
end
n = tau*fs;

% correct signal according to tau
s = s(n+1:end);
s = [s; zeros(n,1)];

%calculate amplitude scaling

zI = s.*2.*cos(ts');
zI = filter(blp,alp,zI);
zI = zI((N/2)+1:end);
zI = [zI; zeros((N/2),1)];

zQ = s.*-2.*sin(ts');
zQ = filter(blp,alp,zQ);
zQ = zQ((N/2)+1:end);
zQ = [zQ; zeros((N/2),1)];


[qI,lagI] = xcorr(zI,cc);
[qQ,lagQ] = xcorr(zQ,cc);


II = find(abs(qI)==max(abs(qI)));
IQ = find(abs(qQ)==max(abs(qQ)));


%Calculate Tau
if qI(II) > qQ(IQ)
   qI = qI(n+1:end);
   qI = [qI; zeros(n,1)];
   A = qI(ceil(end/2))/(fs/2);
else
   qQ = qQ(n+1:end);
   qQ = [qQ; zeros(n,1)];
   A = qQ(ceil(end/2))/(fs/2);
end

% correct signals according to A
zI = zI*(1/(A));
zQ = zQ*(1/(A));


%filter and downsample signals
zI = decimate(zI,20,N,'fir');
zI = zI(1:20000*5);
zI = zI*20;

zQ = decimate(zQ,20,N,'fir');
zQ = zQ(1:20000*5);
zQ = zQ*20;

%last 10 samples distort signal
zI = zI(1:end-10);
zI = [zI ; zeros(10,1)];

A = round(A,1)
tau = round(tau*1e6,2)
end

%filterera
%demodulera
%plocka ut chip fr??n xI
%hitta tau och amplitud fr??n xcorr
%compensera y utifr??n A och Tau
%downsampla 20