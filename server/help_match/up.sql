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
    profile_pic_url TEXT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash BYTEA NOT NULL,
    activated BOOLEAN DEFAULT FALSE,
    user_role user_role_type NOT NULL DEFAULT 'user',
    interests interest_type [] DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);
CREATE TYPE organization_type AS ENUM (
    'non_profit',
    'for_profit',
    'government',
    'community',
    'educational',
    'healthcare',
    'cultural'
);
-- ALTER TYPE organization_type ADD VALUE 'new_type';


CREATE TABLE organizations (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE, -- Each organization is a user
    organization_name VARCHAR(255) UNIQUE NOT NULL,
    profile_icon TEXT DEFAULT '',
    description TEXT DEFAULT '',
    location POINT NOT NULL, 
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    version INTEGER NOT NULL DEFAULT 1,
    org_type organization_type, 
    PRIMARY KEY (id)
);
CREATE TYPE job_status_type AS ENUM (
    'pending',
    'accepted',
    'rejected',
    'finished'
);

CREATE TABLE user_jobs (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE, 
    job_id UUID REFERENCES org_jobs(id) NOT NULL,
    job_status job_status_type DEFAULT 'pending',  
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);
CREATE TABLE reviews (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    organization_id UUID REFERENCES organizations(id) ON DELETE CASCADE,
    rating INT CHECK (rating >= 1 AND rating <= 5), 
    review TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE refresh_tokens (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    version INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE org_jobs (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    org_id UUID REFERENCES organizations(id) ON DELETE CASCADE, 
    job_title VARCHAR(100) NOT NULL,
    description TEXT DEFAULT '',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    version INTEGER NOT NULL DEFAULT 1,
    PRIMARY KEY (id)
);
CREATE TABLE job_chat_rooms (
    id UUID UNIQUE NOT NULL DEFAULT uuid_generate_v1mc(),
    job_id UUID REFERENCES org_jobs(id) ON DELETE CASCADE,
    name VARCHAR(255), 
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
CREATE TABLE group_messages (
    id UUID NOT NULL DEFAULT uuid_generate_v1mc(),
    chat_room_id UUID REFERENCES job_chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE job_chat_members (
    chat_room_id UUID REFERENCES job_chat_rooms(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    left_at TIMESTAMP,
    PRIMARY KEY (chat_room_id, user_id)
)
