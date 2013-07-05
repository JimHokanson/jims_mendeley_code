um = mendeley.user_manager.getInstance;
dm = mendeley.library.raw_doc_manager.getInstance(um.getUser(1));


%doc_ids = dm.em.document_ids;


% m = mendeley.api.options;
% m.return_type = 'raw';
% wtf = dm.em.pvt_service.doc_details(doc_ids{1},'options',m);