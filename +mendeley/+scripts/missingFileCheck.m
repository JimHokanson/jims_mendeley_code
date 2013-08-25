function missingFileCheck()

BASE_PATH = 'C:\Users\RNEL\Documents\Mendeley Desktop\';

um   = mendeley.user_manager.getInstance;
user = um.getUser(1);


%This code would need to change based on the naming scheme


dir_names = sl.dir.listNonHiddenFolders(BASE_PATH);

cur_file_index = 0;
all_names  = cell(1,10000);
all_hashes = cell(1,10000);

for iDir = 1:length(dir_names)
   cur_dir = dir_names{iDir};
   
   %TODO: Would need better check than this ...
      r = sl.dir.getFilesInFolder(fullfile(BASE_PATH,cur_dir),'ext','pdf');
      file_paths = r.file_paths;
      %FORMAT:
      %author1, author2, author3 - year - title
      %OR
      %author1 et al
      %[output,is_matched] = sl.cellstr.regexpSingleMatchTokens(r.file_names,'([^-]*)-\s*(\d+)\s*-\s*([^\.]*)');
      %Column 1: authors
      %Column 2: year
      %Column 3: title
      for iFile = 1:length(file_paths)
         cur_file_index = cur_file_index + 1;
         cur_file_path  = file_paths{iFile};
         all_names{cur_file_index}  = cur_file_path;
         all_hashes{cur_file_index} = sl.crypt.getSHA1(cur_file_path,'is_file',true);
      end
end