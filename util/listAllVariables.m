list = who('*');
for n = 1:1:size(list,1)
    disp([list{n},'='])
    eval(['disp(',list{n},')'])
end 