for i=1:200
    str1 = sprintf('%01d',i);
    slice=Res.Cycs(569:650,(i-1)*100+1:i*100);
    imagesc(abs(slice));
    axis off;
    saveas(gcf, str1, 'png');
end