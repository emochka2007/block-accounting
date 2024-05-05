create table if not exists users (
        id uuid not null,
        seed bytea not null unique,
        created_at timestamp default current_timestamp,
        activated_at  timestamp default null,
        primary key (id, seed)
);

create table if not exists organizations (
        id uuid primary key, 
        name varchar(300) default 'My Organization' not null, 
        created_at timestamp default current_timestamp,
        updated_at timestamp default current_timestamp
);

create index if not exists index_organizations_id
        on organizations (id); 

create table organizations_users (
        organization_id uuid not null, 
        user_id uuid not null, 
        added_at timestamp default current_timestamp,
        updated_at timestamp default current_timestamp,
        is_admin bool default false,
        primary key(organization_id, user_id)
);

create index if not exists index_organizations_users_organization_id_user_id_is_admin
        on organizations_users (organization_id, user_id, is_admin); 

create index if not exists index_organizations_users_organization_id_user_id
        on organizations_users (organization_id, user_id); 

create table if not exists transactions (
        id uuid primary key,
        description text default 'New Transaction', 
        organization_id uuid not null, 
        created_by uuid  not null, 
        amount bigint default 0,

        to_addr bytea not null,

        max_fee_allowed bigint default 0, 
        deadline timestamp default null,

        created_at timestamp default current_timestamp,
        updated_at timestamp default current_timestamp,

        confirmed_at timestamp default null,
        cancelled_at timestamp default null,

        commited_at timestamp default null
);

create index if not exists index_transactions_id_organization_id
        on transactions (organization_id); 

create index if not exists index_transactions_id_organization_id_created_by
        on transactions (organization_id, created_by); 

create index if not exists index_transactions_organization_id_deadline
        on transactions (organization_id, deadline); 

create table transactions_confirmations (
        tx_id uuid not null, 
        user_id uuid not null,
        organization_id uuid not null, 
        created_at timestamp default current_timestamp,
        updated_at timestamp default current_timestamp,
        confirmed bool
);

create index if not exists index_transactions_confirmations_tx_id_user_id_organization_id
        on transactions_confirmations (tx_id, user_id, organization_id);