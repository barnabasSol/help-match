CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE interest_type AS ENUM (
    'non_profit',
    'for_profit',
    'government',
    'community',
    'educational',
    'healthcare',
    'cultural'
);

CREATE TYPE user_role_type AS ENUM ('user', 'organization');

CREATE TABLE IF NOT EXISTS users (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    name VARCHAR(255) NOT NULL,
    username VARCHAR(255) UNIQUE NOT NULL,
    profile_pic_url TEXT DEFAULT '',
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash BYTEA NOT NULL,
    activated BOOLEAN DEFAULT FALSE,
    is_online BOOLEAN DEFAULT TRUE,
    user_role user_role_type NOT NULL DEFAULT 'user',
    interests interest_type [] DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);