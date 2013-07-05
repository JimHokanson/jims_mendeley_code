classdef singleton < sl.obj.handle_light
    %
    %   Class:
    %   mendeley.library.singleton
    %
    
    properties
    end
    
    methods (Static,Hidden)
        function [objs,user_ids,output] = handleSingleton(fh,objs,user_ids,user)
           %
           %
           %    [objs,user_ids,output] = mendeley.library.singleton.handleSingleton(fh,objs,user_ids,user)
            
            cur_user_id = user.getUniqueUserString();
            I = find(strcmp(user_ids,cur_user_id));
            
            if isempty(I)
                temp = fh();
                objs{end+1}   = temp;
                user_ids{end+1} = cur_user_id;
                output = temp;
            else
                output = objs{I};
            end
        end
    end
    
end

