function jsonToProps(obj)

n_raw_docs = length(obj.parsed_json);

parsed_json_local = obj.parsed_json;

titles_local            = cell(1,n_raw_docs);
years_local             = zeros(1,n_raw_docs);
linear_authors_local    = cell(1,n_raw_docs);
publications_local      = cell(1,n_raw_docs);
doc_types_local         = cell(1,n_raw_docs);

for iEntry = 1:n_raw_docs
    temp = parsed_json_local{iEntry};
    
    titles_local{iEntry} = temp.title;
    
    %Years doesn't exist for all entries ...
    try %#ok<TRYNC>
        years_local(iEntry) = sscanf(temp.year,'%f',1);
    end
    
    authors = [temp.authors{:}];
    
    if ~isempty(authors)
        linear_authors_local{iEntry} = {authors.surname};
    end
    
    try
        temp1 = temp.published_in;
    catch
        temp1 = '';
    end
    
    publications_local{iEntry}  = temp1;
    
    doc_types_local{iEntry}     = temp.type;
end

obj.titles = titles_local;
obj.years  = years_local;
obj.linear_authors = linear_authors_local;
obj.publications   = publications_local;
obj.doc_types      = doc_types_local;

mendeley.saveObjectHelper(obj,obj.save_path);

end