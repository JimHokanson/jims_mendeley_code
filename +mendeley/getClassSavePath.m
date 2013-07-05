function save_base_path = getClassSavePath(class_obj)
%getClassSavePath  Returns base save path for a class based on class name
%
%   save_base_path = mendeley.getClassSavePath(class_obj)
%
%   INPUTS
%   =======================================================================
%   class_obj : Instance of a 
%
%   OUTPUTS
%   =======================================================================
%   save_base_path : Directory that the class can save objects in.
%
%
%       folder/+mendeley/+package_2/+my_class
%   TO
%       folder/data/package_2/my_class
%
%   The non-collision of classes ensures the non-collision of save paths.
%   The first package, 'mendeley' is removed to shorten paths.
%   
%    
%
%   TODO: Documentation unfinished
    
    base_path = sl.dir.getMyBasePath('',1);
    
    class_name_parts = regexp(class(class_obj),'\.','split');
    
    save_base_path = sl.dir.createFolderIfNoExist(base_path,'data',class_name_parts{2:end});
end

