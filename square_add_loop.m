clearvars;
cd 'Z:\orca401\work\softCrystal\hf-3c\stm' %working directory
%----------Input------------
numberAtoms = 1752; %number atoms in molecule, used to skip header later
startOrbital = 3281;
endOrbital = 3347;
nameInput = 'hex1_hf-3c.mo'; % input file nambe without XXXa.cube ending
nameOutput = 'sum_squared_hex1_3281-3347.cube'; % output file name
lines2skip = numberAtoms + 7;
fid1 = fopen(nameOutput, 'w'); % open output file
sum = 0;

for i = startOrbital:endOrbital
    cube_i = [nameInput num2str(i) 'a.cube'];
    fid2 = fopen(cube_i,'r');
    for k=1:lines2skip
        nothing = fgets(fid2);
    end
    A = fscanf(fid2, '%E', [3,inf]);
    A2 = A.*A;
    sum = sum + A2;
    fclose(fid2);
end
fprintf(fid1, '%E %E %E %E %E %E \r\n', sum);
fclose(fid1);