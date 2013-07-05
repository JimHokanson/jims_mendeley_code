function saveObjectHelper(obj,save_path)
%
%
%   mendeley.saveObjectHelper(obj,save_path)

s = sl.obj.toStruct(obj); %#ok<NASGU>
save(save_path,'s')
end