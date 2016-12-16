function plotIndices(scrambledIndices, correctIndices) 
x = 1:100;
ya = scrambledIndices(1:100);
yb = correctIndices(1:100);

figure();
subplot(1,2,1);
axis([0 100 0 100]);
xlabel('Player ID');
ylabel('Database Column');
plot(x,ya,'o');
axis equal;
axis square;
title('Scrambled Indices');

subplot(1,2,2);
axis([0 100 0 100]);
xlabel('Player ID');
ylabel('Database Column');
plot(x,yb,'o');
axis equal;
axis square;
title('Correct Indices');


end