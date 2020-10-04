clear all; close all;
x_I=1; y_I=1;           
x_G=700; y_G=700;       
Thr=50;                 
Delta= 30;              

T.v(1).x = x_I;         
T.v(1).y = y_I; 
T.v(1).xPrev = x_I;     
T.v(1).yPrev = y_I;
T.v(1).dist=0;          
T.v(1).indPrev = 0;    

figure(1);
ImpRgb=imread('newmap.png');
Imp=rgb2gray(ImpRgb);
imshow(Imp)
xL=size(Imp,1);
yL=size(Imp,2);
hold on
plot(x_I, y_I, 'ro', 'MarkerSize',10, 'MarkerFaceColor','r');
plot(x_G, y_G, 'go', 'MarkerSize',10, 'MarkerFaceColor','g');
%%
count=1;
for iter = 1:3000
    x_rand=[];

    x_rand(1) = rand * xL;
    x_rand(2) = rand * yL;
    
    x_near=[];

    for i = 1:length(T.v)
        x_near(i) = sqrt((x_rand(1) - T.v(i).x)^2 + (x_rand(2) - T.v(i).y)^2)
    end
    [~,idx] = min(x_near);
    x_near = []
    x_near(1) = T.v(idx).x;
    x_near(2) = T.v(idx).y;
    
    x_new=[];

    ratio = 30 / sqrt((x_rand(1) - x_near(1))^2 + (x_rand(2) - x_near(2))^2)
    x_new(1) = x_near(1) + ratio * (x_rand(1) - x_near(1));
    x_new(2) = x_near(2) + ratio * (x_rand(2) - x_near(2));
    
    if ~collisionChecking(x_near,x_new,Imp) 
       continue;
    end
    count=count+1;
    
    T.v(count).x = x_new(1);
    T.v(count).y = x_new(2);
    T.v(count).xPrev = x_near(1);
    T.v(count).yPrev = x_near(2);
    T.v(count).dist = 30;
    T.v(count).indPrev = idx;
    
    if sqrt((x_new(1)-x_G)^2 + (x_new(2)-y_G)^2) <= Thr
        plot([x_near(1); x_new(1)],[x_near(2); x_new(2)], 'r');
        break;
    end
    
   plot([x_near(1); x_new(1)],[x_near(2); x_new(2)], 'r');
   
   pause(0.1); 
end

if iter < 2000
    path.pos(1).x = x_G; path.pos(1).y = y_G;
    path.pos(2).x = T.v(end).x; path.pos(2).y = T.v(end).y;
    pathIndex = T.v(end).indPrev;
    j=0;
    while 1
        path.pos(j+3).x = T.v(pathIndex).x;
        path.pos(j+3).y = T.v(pathIndex).y;
        pathIndex = T.v(pathIndex).indPrev;
        if pathIndex == 1
            break
        end
        j=j+1;
    end 
    path.pos(end+1).x = x_I; path.pos(end).y = y_I;
    for j = 2:length(path.pos)
        plot([path.pos(j).x; path.pos(j-1).x;], [path.pos(j).y; path.pos(j-1).y], 'b', 'Linewidth', 3);
    end
else
    disp('Error, no path found!');
end


