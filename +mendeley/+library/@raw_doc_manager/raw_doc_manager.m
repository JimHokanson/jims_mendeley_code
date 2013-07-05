classdef raw_doc_manager < mendeley.library.singleton
    %
    %   Class:
    %   mendeley.library.raw_doc_manager
    %
    %   This clas holds the raw documents returned from Mendeley.
    %
    %   See Also:
    %   mendeley.library.entry_manager
    
    properties
        doc_data          %cell array json
        doc_ids      = {} %(cellstr)
        doc_versions = [] %(numeric array)
        last_sync         %Matlab time of last sync of documents.
    end
    
    properties
        user    %Class: mendeley.user_manager
        em      %Class: mendeley.library.entry_manager
    end
    
    properties (Hidden)
        save_path
    end
    
    %Constructor ==========================================================
    methods (Access = private)
        function obj = raw_doc_manager(user)
            
            obj.em        = mendeley.library.entry_manager.getInstance(user);
            obj.user      = user;
            obj.save_path = user.getUserSpecificClassSavePath(obj);
            
            mendeley.loadObjectHelper(obj,obj.save_path);
        end
    end
    
    methods
        function raw_doc_entry = docIndex(obj,index)
            %TODO: Return index of entry above
        end
    end
    
    methods (Static)
        function obj = getInstance(user)
            %
            %   obj = getInstance(user)
            %
            %   INPUTS
            %   ===========================================================
            %   user : Class: mendeley.user
            
            persistent objs user_ids
            fh = @()mendeley.library.raw_doc_manager(user);
            [objs,user_ids,obj] = mendeley.library.singleton.handleSingleton(fh,objs,user_ids,user);
        end
    end
    
end

