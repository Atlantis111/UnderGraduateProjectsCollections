
%test_juzhen = [1 2 3 4 5;10 20 30 40 50;200 300 400 500 600];

% 240:469   470:559   560:640
% 0:300   300:520   520:600   600:620  620:800
slice=abs(CyclicSpec(500:520,1:10000));
y_shadow =std(slice,1,1);
y_shadow_x=1:10000;
bar(y_shadow_x,y_shadow)


%S =std(abs(CyclicSpec),1,2);    %计算每行标准差
%w=reshape(S,1,[]);
%x=1:1024;
%bar(x,w)