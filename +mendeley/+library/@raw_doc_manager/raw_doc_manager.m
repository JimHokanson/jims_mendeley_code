classdef raw_doc_manager < mendeley.library.singleton
    %
    %   Class: (Singleton) -> .getInstance(user) 
    %   mendeley.library.raw_doc_manager 
    %
    %   This class holds the raw documents returned from Mendeley.
    %
    %   Importantly, this class holds onto the raw data so that
    %   reprocessing of the format is easy to do locally.
    %
    %   DATA EDITS
    %   ---------------------------------------------------------
    %   1. Sees changes from Mendeley sync
    %
    %   See Also:
    %   mendeley.library.entry_manager

    %OTHER METHODS
    %--------------------------------------------------
    %mendeley.library.raw_doc_manager.sync
    
    properties
        doc_data          %cell array, raw json
        doc_ids      = {} %(cellstr)
        doc_versions = [] %(numeric array)?? - or should I make this a char-matrix???
        last_sync         %Matlab time of last sync of documents.
    end
    
    properties
        user    %mendeley.user_manager
        em      %mendeley.library.entry_manager
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
        function disp(obj)
           fprintf('User: %s\n',obj.user.user_name)
           fprintf('Data: -----------------\n');
           %TODO: Implement property help display class
           
           obj.disp2();
           
           fprintf('\nMETHODS:\n------------------------\n');
           fprintf('sync  : syncs log with the server\n')
           fprintf('disp2 : normal object display method\n')
        end
        function disp2(obj)
           builtin('disp',obj)
        end
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

