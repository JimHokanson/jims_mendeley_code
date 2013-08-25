classdef entry_manager < mendeley.library.singleton
    %
    %   Class: (Singleton) -> .getInstance(user) 
    %   mendeley.library.entry_manager
    %
    %   Entries in Mendeley are entries in their database. The consist of
    %   and ID identifying the entry, and then associated data. This class
    %   only keeps track of the ID and the time an entry was last updated.
    %
    %   This is basically a wrapper class for the method documented at:
    %   http://apidocs.mendeley.com/home/user-specific-methods/user-library
    %
    %   Currently this method keeps a synced version of the library on
    %   disk.
    
    properties
       VERSION = 1
       user         %Class: mendeley.user
       pvt_service  %Class: mendeley.api.private_service
       
       %PROPERTIES ...
       %-------------------------------------------------------------------
       document_ids        %(cellstr), string ids of entries returned
       %by Mendeley. This can be used to request more information about
       %a document.
       document_versions   %(numeric array), 
       last_sync   %Matlab time of last sync
    end
    
    properties (Hidden)
       save_path 
    end
    
    methods (Access = private)
        function obj = entry_manager(user)
           %
           %    mendeley.library.entry_manager
           %
           %    TEST CODE:
           %    um = mendeley.user_manager.getInstance;
           %    em = mendeley.library.entry_manager.getInstance(um.getUser(1));
           %
           obj.user        = user;
           obj.pvt_service = user.pvt_service;
           obj.save_path   = user.getUserSpecificClassSavePath(obj);
           
           mendeley.loadObjectHelper(obj,obj.save_path);
        end
    end
    
    methods (Static)
        function obj = getInstance(user)
            %
            %
            %   obj = getInstance(user)
            %
            %   INPUTS
            %   ===========================================================
            %   user : Class: mendeley.user
            
            persistent objs user_ids
            fh = @()mendeley.library.entry_manager(user);
            [objs,user_ids,obj] = mendeley.library.singleton.handleSingleton(fh,objs,user_ids,user);
        end
    end
    
    
    methods 
        function sync(obj,varargin)
           %
           %    sync(obj,varargin)
           %
           %    TODO: Determine better exposure of timeout properties for 
           %    urlread2
           %
           %    It was taking too long, I had to increase it ...
           %
           %    OPTIONAL INPUTS
           %    ====================================
           %    show_text : (default true)
           
           in.show_text = true;
           in = sl.in.processVarargin(in,varargin);
           
           if in.show_text
               fprintf('Syncing document ids with Mendeley server\n')
           end
           
           temp = obj.pvt_service.doc_libraryAll; 
           %Class: mendeley.api.pvt_response.doc_library
           %doc_ids      - cellstr
           %doc_versions - numeric, time of last update (matlab time)
           
           obj.document_ids      = temp.doc_ids;
           obj.document_versions = temp.doc_versions;
           obj.last_sync         = now;
           
           mendeley.saveObjectHelper(obj,obj.save_path);
        end
        function status_output = resolveStatus(obj,doc_ids,doc_versions)
            %
            %
            %   status_output = resolveStatus(obj,doc_ids,doc_versions)
            %
            %   FULL PATH:
            %   mendeley.library.entry_manager.resolveStatus
            
            status_output = mendeley.library.doc_id_status; 
            
            %TODO: I plan on making a bidirectional ismember ...
            
            mask = ismember(obj.document_ids,doc_ids);
            
            status_output.new_ids      = obj.document_ids(~mask);
            status_output.new_versions = obj.document_versions(~mask);
            
            [mask,loc] = ismember(doc_ids,obj.document_ids);
            
            status_output.deleted_mask = ~mask;
            
            temp_out_of_date = doc_versions(mask) < obj.document_versions(loc(mask));
            
            out_of_date_mask = false(size(mask));
            out_of_date_mask(mask) = temp_out_of_date;

            status_output.out_of_date_mask = out_of_date_mask;
            
        end
    end
    
end

