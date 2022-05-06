function plot_sig(t,y,fs)
figure;
subplot(2,1,1);
plot(t,y);
xlabel('Time(S)');
title('Signal versus Time');

subplot(2,1,2);
f = fs*linspace(0, 1/2, floor(numel(y)/2));
fr = fft(y);
fr = abs(fr)/numel(y);
fr = fr(1:floor(end/2));
fr(2:end-1) = 2*fr(2:end-1);
plot(f, fr);
xlabel('Time(S)');
title('Frequency Response');
end

