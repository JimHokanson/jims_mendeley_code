classdef user_manager < sl.obj.handle_light
    %
    %   Class:
    %   mendeley.user_manager
    %
    %   isValidUser
    %   getUserNames
    %   addUser
    %   getUser
    
    %allow alias and changing of names
    
    properties (Constant,Hidden)
        VERSION = 1;
    end
    
    properties (Hidden)
        data_path
    end
    
    properties
        %getAppKey - called by constructor
        %This object will not exist without these being populated ...
        consumer_key     = '' %string
        consumer_secret  = '' %string
        
        user_names       = {} %cellstr
        user_ids         = {}
        access_tokens    = {} %
        access_secrets   = {}
    end
    
    methods (Access = private)
        function obj = user_manager()
            obj.data_path = fullfile(mendeley.getClassSavePath(obj),'data.mat');
            obj.load();
            
            
            if isempty(obj.consumer_key)
                obj.getAppKey();
            end
        end
    end
    
    methods (Hidden)
        function getAppKey(obj)
            %run gui for pasting
            %inputdlg
            
            response = inputdlg({'Consumer Key' 'Consumer Secret'},'Please paste in api info',[1 50; 1 50]);
            %Empty on cancel
            if isempty(response)
                error('Retrieval of App Key info failed')
            end
            
            obj.consumer_key    = strtrim(response{1});
            obj.consumer_secret = strtrim(response{2});
            obj.save();
        end
        function load(obj)
            %
            %   load(obj)
            
            
            if exist(obj.data_path,'file')
                h = load(obj.data_path);
                
                if h.s.VERSION ~= obj.VERSION
                   error('Unhandled version change') 
                end

                sl.struct.toObject(obj,h.s);
            end
        end
        function save(obj)
            
            w = warning('off','MATLAB:structOnObject');
            s = struct(obj); %#ok<NASGU>
            warning(w);
            
            save(obj.data_path,'s')
        end
    end
    
    methods (Static)
        %         function changeAPIKey()
        %
        %         end
        function obj = getInstance()
            %
            %   um = mendeley.user_manager.getInstance
            
            
            persistent uniqueInstance
            if isempty(uniqueInstance)
                obj = mendeley.user_manager();
                uniqueInstance = obj;
            else
                obj = uniqueInstance;
            end
        end
    end
    
    methods
        function disp(obj)
           %Show users and ids
           n_users = length(obj.user_names);
           fprintf('Registered Users\n----------------------\n');
           for iUser = 1:n_users
              fprintf('%d) %s\n',iUser,obj.user_names{iUser}); 
           end
           fprintf('\nMETHODS:\n------------------------\n');
           fprintf('addUser: run method to add a user\n')
           fprintf('disp2  : normal object display method\n')
           fprintf('getUser: pass in index of user to get user object\n')
        end
        function disp2(obj)
           builtin('disp',obj) 
        end
        %         function refreshUserEmail()
        %             %In case the email changes, allow refreshing all email ...
        %         end
        function user_obj = getUser(obj,index)
            %getUser
            %   
            %   user_obj = getUser(obj,index)
            %
            %   Return user instance object
            %
            %   Outputs
            %   ===============================================
            %   user_obj : Class: mendeley.user
            
            user_obj = mendeley.user(...
                obj.user_names{index},...
                obj.getPrivateCreds(index),...
                obj.user_ids{index}); 
        end
        function addUser(obj)
            %addUser
            %
            %   addUser(obj)
            %
            %   Launches GUI to get user to ok access.
            %
            %   NOTE: User id is gained from having user login
            %   to Mendeley to authorize client. Following authorization
            %   we can use the client info to request the profile of the
            %   user.
            
            [access_token,secret] = mendeley.api.getAccessToken(...
                obj.consumer_key,...
                obj.consumer_secret);
            
            p_oauth = getPrivateOauth(obj,access_token,secret);
            
            r = p_oauth.profile_info();
            %Class: mendeley.api.pvt_response.profile_info
            
            %TODO: Provide filtering on unique id
            %erase previous entry ...
            %Show warning if this is done
            
            unique_id = r.getUniqueID;
            
            %I = strcmp(obj.user_ids,unique_id) ...
            
            obj.user_name{end+1}      = r.name;
            obj.user_ids{end+1}       = r.getUniqueID;
            obj.access_tokens{end+1}  = access_token;
            obj.access_secrets{end+1} = secret;
            
            obj.save;
        end
    end
    
    methods (Hidden)
        %NOTE: I don't necessarily like the organization of these files ...
        function p_oauth = getPrivateOauthByIndex(obj,index)
            %
            
            p_oauth = obj.getPrivateOauth(obj.access_tokens{index},obj.access_secrets{index});
        end
        function p_creds = getPrivateCreds(obj,index)
            p_creds = oauth.creds.private(obj.consumer_key,obj.consumer_secret,...
                obj.access_tokens{index},obj.access_secrets{index});
        end
        function p_oauth = getPrivateOauth(obj,access_token,secret)
            %
            %
            %    p_oauth = getPrivateOauth(obj,access_token,secret)
            
            a = oauth.creds.private(obj.consumer_key,obj.consumer_secret,access_token,secret);
            p_oauth = mendeley.api.private_service(a);
            
        end
    end
    
end

