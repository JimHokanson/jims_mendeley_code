classdef parsed_doc_manager < mendeley.library.singleton
    %
    %   Class: (Singleton) -> .getInstance(user) 
    %   parsed_doc_manager
    %
    %   This class hold the parsed entries.
    %
    %   Data synchornization ???
    %   ------------------------------------------
    
    
    properties (Constant)
       VERSION = 1 
    end
    
    properties
       parsed_json
       titles
       years
       linear_authors
       publications
       doc_types
    end
    
    properties
       rdm
       user
    end
    
    properties (Hidden)
       save_path 
    end
    
    %Constructor ==========================================================
    methods (Access = private)
        function obj = parsed_doc_manager(user)
            %
            %   Class:
            %   mendeley.library.parsed_doc_manager.getInstance(user)
            %
            
            obj.rdm       = mendeley.library.raw_doc_manager.getInstance(user);
            obj.user      = user;
            obj.save_path = user.getUserSpecificClassSavePath(obj);
            
            mendeley.loadObjectHelper(obj,obj.save_path);
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
            fh = @()mendeley.library.parsed_doc_manager(user);
            [objs,user_ids,obj] = mendeley.library.singleton.handleSingleton(fh,objs,user_ids,user);
        end
    end
    
    methods
        function syncWithMendeley()
           %Again, not sure how to handle this ...
        end
        function syncLocally()
           %Only with dm??
           %Not sure how I want to handle this ...
        end
        function reparseAll(obj)
           
           raw_doc_data = obj.rdm.doc_data;
           n_raw_docs   = length(raw_doc_data);
           
           parsed_json_local = cell(1,n_raw_docs);

                       
           for iEntry = 1:n_raw_docs
              cur_raw_doc_data = raw_doc_data{iEntry};
              temp = sl.io.parseJSON(cur_raw_doc_data); 
              parsed_json_local{iEntry} = temp;
           end
           
           obj.parsed_json = parsed_json_local;
           
           obj.jsonToProps();
           
        end
       
        function parseEntries(obj)
           %What does this even mean??? 
        end
    end
    
end

