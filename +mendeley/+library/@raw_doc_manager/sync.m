function sync(obj,varargin)
%
%
%   sync(obj,varargin)
%
%   OPTIONAL INPUTS
%   =======================================================================
%   sync_global : (default false), if true then 
%   display_mod : (default 50), how many entries to run before displaying
%       a printed update message
%
%
%   See Also:
%   mendeley.library.entry_manager
%
%   FULL PATH:
%   mendeley.library.raw_doc_manager.sync

in.sync_global = false;
in.display_mod = 50;
in = sl.in.processVarargin(in,varargin);

if in.sync_global
    obj.em.sync();
end

%This function checks the status of the documents against either the 
%most up to date information from the server or from the last time that the
%server was synced.
%
%mendeley.library.entry_manager
s = obj.em.resolveStatus(obj.doc_ids,obj.doc_versions);
%mendeley.library.doc_id_status

%NOTE: We request just the raw output, no processing
m = mendeley.api.options;
m.return_type = 'raw';

%Step 1:
%Update out of date entries ...
if any(s.out_of_date_mask)
    error('NYI')
end

%Step 2:
%Delete old entries
if any(s.deleted_mask)
    error('NYI')
end

%Step 3:
%Retrieve new entries ...
new_ids = s.new_ids;
new_versions = s.new_versions;

n_new = length(new_ids);

if n_new ~= 0
    temp_data = cell(1,n_new);
    fprintf('Retrieving %d docs\n',n_new);
    for iNew = 1:n_new
        %TODO: Add progress printout ...
        if mod(iNew,in.display_mod) == 0
            fprintf('Retrieving %d/%d docs\n',iNew,n_new);
        end
        %mendeley.api.private_service.doc_details
        temp_data{iNew} = obj.em.pvt_service.doc_details(new_ids{iNew},'options',m);
    end
    obj.doc_data     = [obj.doc_data temp_data];
    obj.doc_ids      = [obj.doc_ids new_ids];
    obj.doc_versions = [obj.doc_versions new_versions];
end

%   -----------------------------------------------------------
%   out_of_date - new version available
%   deleted     - no longer in the library
%   missing     - not present
%   un_parsed   - raw data present but not parsed to newest version ...

mendeley.saveObjectHelper(obj,obj.save_path);
end