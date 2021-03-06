function x = sender(xI,xQ)
fs = (length(xI)/5)*20;
fc = 135000;
B = 10000;
t = linspace(0,6,fs*6);
N = 500;

%upsample signals to 400kHz
xI_t = upsample(xI,20);
xQ_t = upsample(xQ,20);

%Filter after upsample
[b,a] = fir1(N,B/(fs/2));
xI_t = filter(b,a,xI_t);
xI_t = xI_t((N/2)+1:end);
xI_t = [xI_t; zeros((N/2),1)];

xQ_t = filter(b,a,xQ_t);
xQ_t = xQ_t((N/2)+1:end);
xQ_t = [xQ_t; zeros((N/2),1)];

%Create chirp of one second with sampling 400kHz to add at the end of xI, add zeros to xQ.
tc = linspace(0,1,fs);
c = chirp(tc,0,1,200);
z = zeros(1,fs);

%Append chirp and zeros to xI resp. xQ.
xI_t = cat(2,xI_t',c);
xQ_t = cat(2,xQ_t',z);

%IQ modulation
ts = (2*pi*fc)*t;
x = xI_t.*cos(ts) - xQ_t.*sin(ts);
x = x';
end