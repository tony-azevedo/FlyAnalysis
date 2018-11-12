cd 'B:\Raw_Data'

%%
folders = dir('1*');
FID = fopen('listofmissingimages.txt','w');

for f = 1:numel(folders)
    cd(folders(f).name)
    
    cells = dir('1*');
    for c = 1:numel(cells)
        cd(cells(c).name);
        
        keims = dir('*keimograph*');
        ims = dir('*_Image_*');
        if length(keims)>1 
            
            mismatchcnt = 0;
            for k = 1:length(keims)
                keimname = keims(k).name;
                matchim = dir([regexprep(keimname,{'.mat','_keimograph_'},{'_','_Image_'}),'*']);
                if numel(matchim)==0
                    mismatchcnt = mismatchcnt+1;
                end
                if mismatchcnt>3
                    fprintf('%s:\t%d keims\t%d ims\n',cells(c).name,length(keims),length(ims));
                    fprintf(FID,'%s:\t%d keims\t%d ims\n',cells(c).name,length(keims),length(ims));
                    break
                end
            end
        end
        cd(fullfile('B:\Raw_Data',folders(f).name))
    end

    
    cd 'B:\Raw_Data'
end

fclose(FID)

