function plot_compare(t,fs,x,z)

figure;
subplot(2,2,1);
plot(t,z);
xlabel('Time(S)');
title('Signal versus Time');

subplot(2,2,2);
plot(t,x);
xlabel('Time(S)');
title('Signal versus Time');

subplot(2,2,3);
f = fs*linspace(0, 1/2, floor(numel(z)/2));
fr = fft(z);
fr = abs(fr)/numel(z);
fr = fr(1:floor(end/2));
fr(2:end-1) = 2*fr(2:end-1);
plot(f, fr);
xlabel('freq(hz)');
title('Frequency Response');

subplot(2,2,4);
f = fs*linspace(0, 1/2, floor(numel(x)/2));
fr = fft(x);
fr = abs(fr)/numel(x);
fr = fr(1:floor(end/2));
fr(2:end-1) = 2*fr(2:end-1);
plot(f, fr);
xlabel('freq(hz)');
title('Frequency Response');
end

