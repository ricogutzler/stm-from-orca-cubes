clearvars;
n_voxel = 256; %number of voxels, only works for nx=ny=nz
x_voxel = 0.733477; %size of voxel along x
y_voxel = 0.713935; %size of voxel along y
z_voxel = 0.090021; %size of voxel along z
fid1 = fopen('Z:\orca401\work\softCrystal\hf-3c\stm\sum_squared_hex1_3281-3347.cube', 'r'); %open file sq.cube with identifier fid1
Cube = fscanf(fid1, '%E', inf); %define 1D column vector Cube of size and read fid1 into it. this reads the whole cube.

Cube(Cube < 0.50E-8) = 0; %set all elements smaller X to 0
%Cube(Cube > 1) = 0; %set all elements greater X to 0

zyx = reshape(Cube,n_voxel,n_voxel,n_voxel); % 3D matrix with z increasing along rows, y increasing along columns, and x along pages

xy = zeros(n_voxel); %create matrix n_voxel x n_voxel in size with all elements 0
for x = 1:n_voxel 
    for y = 1:n_voxel
        for z = 1:n_voxel
            if zyx(z,y,x) ~= 0
                height=z*z_voxel;
                height2=z*z_voxel-10;
                if height2 < 0
                    xy(y,x) = 0;
                else
                    xy(y,x)=height2; %write the hight z of those voxels which have the desired density into the matrix xy
                end    
            end
        end
    end    
end    

%----------new colormap------------
Nmap = 64;
cMin2 = [1 1 1];
cMax2 = [1 0 0];
cMap2 = zeros(Nmap,3);
for i = 1:Nmap;
    cMap2(i,:) = cMin2*(Nmap - i)/(Nmap - 1) + cMax2*(i - 1)/(Nmap - 1);
end

%----------new colormap like thermiccool from WSXM------------
Nmap = 258 
cMin1 = [0 0 0];
cInt1 = [0 1 1];
cInt11 = [1 0 0];
cMax1 = [1 1 0];
cMap1 = zeros(Nmap, 3);
for i = 1:(Nmap/3);
    cMap1(i,:) = cMin1*((Nmap/3) - i)/((Nmap/3) - 1) + cInt1*(i-1)/((Nmap/3) - 1);
end
for i = (Nmap/3+1):(2/3*Nmap);
    cMap1(i,:) = cInt1*((2/3*Nmap) - i)/((2/3*Nmap) - (Nmap/3+1)) + cInt11*(i-((Nmap/3+1)))/((2/3*Nmap) - (Nmap/3+1));
end
for i = 2*Nmap/3+1:Nmap;
    cMap1(i,:) = cInt11*((Nmap) - i)/((Nmap) - (2*Nmap/3+1)) + cMax1*(i-(2*Nmap/3+1))/((Nmap) - (2*Nmap/3+1));
end
colormap(cMap1);
surf(xy,'EdgeColor','none','LineStyle','none');
view(2);                                %Predefined Top-View
daspect([x_voxel y_voxel z_voxel]);     %XYZ-aspect ratio


fprintf(1,'%E %E %E %E %E %E \r\n', Cube);
%display(xy);
fclose(fid1);
display('done');

