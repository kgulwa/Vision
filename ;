                                Table "public.comments"
   Column   |              Type              | Collation | Nullable |      Default      
------------+--------------------------------+-----------+----------+-------------------
 uid        | uuid                           |           | not null | gen_random_uuid()
 content    | text                           |           |          | 
 parent_uid | uuid                           |           |          | 
 pin_uid    | uuid                           |           | not null | 
 user_uid   | uuid                           |           | not null | 
 created_at | timestamp(6) without time zone |           | not null | 
 updated_at | timestamp(6) without time zone |           | not null | 
 id         | uuid                           |           | not null | gen_random_uuid()
Indexes:
    "comments_pkey" PRIMARY KEY, btree (uid)
Foreign-key constraints:
    "fk_rails_72f443c8a3" FOREIGN KEY (pin_uid) REFERENCES pins(uid)

