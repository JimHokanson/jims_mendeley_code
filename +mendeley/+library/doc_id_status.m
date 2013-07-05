classdef (Hidden) doc_id_status
    %
    %
    %   Class:
    %   mendeley.library.doc_id_status
    %
    %   Result class
    %
    %   See Also:
    %   mendeley.library.entry_manager.resolveStatus
    
    properties
       new_ids         %[1 x n_new]
       new_versions    %[1 x n_new]
       
       deleted_mask     %[1 x n_old]
       out_of_date_mask %[1 x n_old] Indicates true if still present but out of date
    end
    
    methods
    end
    
end

