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
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    organization_name VARCHAR(255) UNIQUE NOT NULL,
    profile_icon TEXT DEFAULT '',
    image_posts TEXT[] DEFAULT '{}',
    description TEXT DEFAULT '',
    location POINT NOT NULL, 
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_verified BOOLEAN DEFAULT FALSE,
    version INTEGER NOT NULL DEFAULT 1,
    org_type organization_type, 
    PRIMARY KEY (id)
);