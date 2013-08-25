## jims_mendeley_code ##

My code for interfacing with Mendeley, a work in progress ...

## Requirements ##
1. oauth package
2. mendeley api package
3. standard library package

## Sample Code ##
```Matlab
um = mendeley.user_manager.getInstance;
um.addUser();
user = um.getUser(1);
em = mendeley.library.entry_manager.getInstance(user);
````

## Near term goals ##

1. Basic search functionality
  - I'd like to have basic search entry fields and to be able to try and match these fields.
  - This exists in the old version but needs to be resurrected
- tag updater
  - Now that we can edit entries, I want to be able to add tags. Ideally this will provide suggestions for tags based on tags already entered.
- tag viewer 
  - This might actually just be incorporated into the updater, the idea is to be enter a tag and to have a list of all other tags that are associated with the specified tag.
- for non-synced documents, check hash vs database hash, does fixing the DB hash allow syncing????