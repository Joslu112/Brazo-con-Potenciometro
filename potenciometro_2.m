%% Limpia la memoria de variables
clear all
close all
clc

%% Cierra y elimina cualquier objeto de tipo serial 
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
end

%% Creación de un objeto tipo serial
arduino = serial('COM3','BaudRate',9600);
fopen(arduino);
if arduino.status == 'open'
    disp('Arduino conectado correctamente');
else
    disp('No se ha conectado el arduino ');
    return
end

prompt='Introduce el valor de la distancia del vector uno:\n';
L1=input(prompt);

prompt='Introduce el valor de la distancia del vector uno:\n';
L2=input(prompt);

p1 = [0 0 0]';

while 1 
    clf
    printAxis();
    a = fscanf(arduino,'%d,%d')';
    angdeg = (a(1)-512)*130/512;
    theta1_rad = deg2rad(angdeg);
    
       %Matriz de rotacion en Z
        Rz= [cos(theta1_rad) -sin(theta1_rad)   0    0;
             sin(theta1_rad)  cos(theta1_rad)   0    0; 
                  0             0               1    0;
                  0             0               0    1];
           
        %Matriz de traslacion en X
        Tx=[1   0    0   L1;
            0   1    0   0 ;
            0   0    1   0 ;
            0   0    0   1];     

        T1=Rz*Tx;
        p2=T1(1:3,4);
        eje_x1=T1(1:3,1);
        eje_y1=T1(1:3,2);
        
        line([p1(1) p2(1)],[p1(2) p2(2)],[p1(3) p2(3)],'color',[0 0 0],'linewidth',5);
        line([p1(1) eje_x1(1)],[p1(2) eje_x1(2)],[p1(3) eje_x1(3)],'color',[1 0 0],'linewidth',5);
        line([p1(1) eje_y1(1)],[p1(2) eje_y1(2)],[p1(3) eje_y1(3)],'color',[0 1 0],'linewidth',5);
        
        
        printAxis();
        angdeg2 = (a(2)-512)*130/512;
        theta2_rad = deg2rad(angdeg2);
        
        %Matriz de rotacion en Z
        TRz2=[cos(theta2_rad) -sin(theta2_rad) 0 0 ;
              sin(theta2_rad)  cos(theta2_rad) 0 0 ; 
                0       0    1 0 ; 
                0       0    0 1];
        
        %Matriz de traslacion en X
        Tx2=[ 1  0  0  L2;
              0  1  0  0 ; 
              0  0  1  0 ;
              0  0  0  1];
          
        T2=TRz2*Tx2;
        Tf=T1*T2;
        
        p3=Tf(1:3,4);
        eje_x2=p2+Tf(1:3,1);
        eje_y2=p2+Tf(1:3,2);
        eje_x3=p3+Tf(1:3,1);
        eje_y3=p3+Tf(1:3,2);
        
        line([p2(1) p3(1)],[p2(2) p3(2)],[p2(3) p3(3)],'color',[.1 .9 .9],'linewidth',5);
        line([p2(1) eje_x2(1)],[p2(2) eje_x2(2)],[p2(3) eje_x2(3)],'color',[1 0 0],'linewidth',5);
        line([p2(1) eje_y2(1)],[p2(2) eje_y2(2)],[p2(3) eje_y2(3)],'color',[0 1 0],'linewidth',5);
        line([p3(1) eje_x3(1)],[p3(2) eje_x3(2)],[p3(3) eje_x3(3)],'color',[1 0 0],'linewidth',5);
        line([p3(1) eje_y3(1)],[p3(2) eje_y3(2)],[p3(3) eje_y3(3)],'color',[0 1 0],'linewidth',5);
        

       %Matriz de rotacion en Z
       TRz2= [cos(theta2_rad) -sin(theta2_rad)   0    0;
              sin(theta2_rad)  cos(theta2_rad)   0    0; 
                   0             0               1    0;
                   0             0               0    1];
               
        %Matriz de traslacion en X
        Tx2=[1   0    0   L2;
             0   1    0   0 ;
             0   0    1   0 ;
             0   0    0   1];
        
        T2=TRz2*Tx2;
        Tf=T1*T2;
        
        p3=Tf(1:3,4);
        eje_x2=p2+Tf(1:3,1);
        eje_y2=p2+Tf(1:3,2);
        eje_x3=p3+Tf(1:3,1);
        eje_y3=p3+Tf(1:3,2);
        
        line([p2(1) p3(1)],[p2(2) p3(2)],[p2(3) p3(3)],'color',[.1 .9 .9],'linewidth',4);
        line([p2(1) eje_x2(1)],[p2(2) eje_x2(2)],[p2(3) eje_x2(3)],'color',[1 0 0],'linewidth',5);
        line([p2(1) eje_y2(1)],[p2(2) eje_y2(2)],[p2(3) eje_y2(3)],'color',[0 1 0],'linewidth',5);
        line([p3(1) eje_x3(1)],[p3(2) eje_x3(2)],[p3(3) eje_x3(3)],'color',[1 0 0],'linewidth',5);
        line([p3(1) eje_y3(1)],[p3(2) eje_y3(2)],[p3(3) eje_y3(3)],'color',[0 1 0],'linewidth',5);
      
        pause(0.01)    
end

%% Cierre de puertos 
fclose(arduino);
delete(arduino);
clear all; 