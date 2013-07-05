function loadObjectHelper(obj,load_path)
%
%   mendeley.loadObjectHelper

if exist(load_path,'file')
    %TODO: Load file ...
    h = load(load_path);
    s = h.s;
    
    %TODO: Check version ...
    
    sl.struct.toObject(obj,s);
end

end