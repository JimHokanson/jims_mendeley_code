classdef user < sl.obj.handle_light
    %
    %
    %   Class:
    %   mendeley.user
    %
    %   What can the user do?
    %   ------------------------------------------------
    %   Not sure yet. The user is starting to look like the entry point
    %   to other things instead of the library ...
    %
    %   
    %   See Also:
    %   mendeley.user_manager
    %   mendeley.user_manager.getUser
    
    properties
       user_name        %char
       profile_id       %char - I'm hoping this a unique identifier ...
       private_creds    %oauth.creds.private
       raw_doc_manager  %Class: mendeley.library.raw_doc_manager
    end
    
    %Publically accessed ...
    properties
       pvt_service   %Class: mendeley.api.private_service
    end
    
    methods
        function obj = user(user_name,private_creds,profile_id)
           obj.user_name     = user_name;
           obj.profile_id    = profile_id;
           obj.pvt_service   = mendeley.api.private_service(private_creds);
           
        end
        function user_string = getUniqueUserString(obj)
           %
           %    This should be a string which will uniquely id the user
           
           user_string = obj.profile_id;
        end
    end
    
    %Save, load, pathing ==================================================
    methods
        function save_path = getUserSpecificClassSavePath(obj,other_obj)
            %getUserSpecificClassSavePath
            %
            %   save_path = getUserSpecificClassSavePath(obj,other_obj)
           user_string  = obj.getUniqueUserString();
           base_path    = mendeley.getClassSavePath(other_obj);
           file_name    = sprintf('u_%s.mat',user_string);
           save_path    = fullfile(base_path,file_name);  
        end
    end
    
    
end

