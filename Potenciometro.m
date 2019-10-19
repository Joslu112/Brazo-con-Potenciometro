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
    disp('Arduino conectado correctamente \n');
else
    disp('No se ha conectado el arduino \n');
    return
end

prompt= 'Introduce el valor de la distancia del vector uno:\n';
l1 = input(prompt);
p1 = [0 0 0]';

while true
    clf
    printAxis();
    valor_con_offset = fscanf(arduino,'%d');
    theta1_deg = ((valor_con_offset(1))-512)*130/512;
    theta1_rad = deg2rad(theta1_deg);
    
    %Matriz de rotacion en Z
    TRz1= [cos(theta1_rad) -sin(theta1_rad)   0    0;
           sin(theta1_rad)  cos(theta1_rad)   0    0; 
              0             0               1    0;
              0             0               0    1];

    %Matriz de traslacion en X
    Ttx1=[1   0    0   l1;
          0   1    0   0 ;
          0   0    1   0 ;
          0   0    0   1];
      
      T1=TRz1*Ttx1;
      p2=T1(1:3,4);
   
      ejex_1=TRz1(1:3,1);
      ejey_1=TRz1(1:3,2);
      
      line([p1(1) ejex_1(1)], [p1(2) ejex_1(2)],[p1(3) ejex_1(3)],'color',[1 0 0],'linewidth',6);
      line([p1(1) ejey_1(1)], [p1(2) ejey_1(2)],[p1(3) ejey_1(3)],'color',[0 1 0],'linewidth',6);
      
      line([p1(1) p2(1)], [p1(2) p2(2)],[p1(3) p2(3)],'color',[.1 .9 .9],'linewidth',5);
      pause(0.01);   
end

%% Cierre de puertos 
fclose(arduino);
delete(arduino);
clear all; 