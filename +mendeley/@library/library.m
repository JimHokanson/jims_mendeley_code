classdef library < mendeley.handle_light
    %
    %
    %   loadByUserName(user_name)
    %   loadByUserInstance(user_instance)
    %   
    %
    %   Functions the library should accomplish:
    %   1) Hold all documents in library
    %   2) get new documents
    %   3) make sure contents are up to date
    %   4) reprocess (should be internal)
    %
    %   Current Status:
    %   ===================================================================
    %   This currently is not being used. I have instead been focusing on
    %   simpler classes:
    %   
    %   Eventually I might incorporate these into the library ...
    %
    %   

    
    properties
       pvt_service      %Class: mendeley.api.private_service
       
       id_version_map   %containers.Map
       %key  : id
       %value: version
       user             %Class: mendeley.user
       
       em   %Class: mendeley.library.entry_manager
       raw_docs
       doc_status
        %   -----------------------------------------------------------
        %   out_of_date - new version available
        %   deleted     - no longer in the library
        %   missing     - not present
        %   un_parsed   - raw data present but not parsed to newest version ... 
    end
    
    methods
        function obj = library(user_name_or_obj)
           
           if ischar(user_name_or_obj)
              %?? - has this been implemented????
              obj.user = mendeley.user_manager.getUser(user_name_or_obj); 
           else
              obj.user = user_name_or_obj;
           end
            
           obj.pvt_service = obj.user.pvt_service;
           
           obj.em = mendeley.library.entry_manager(obj.user);
        end
    end
    
end

