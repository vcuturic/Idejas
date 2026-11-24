CREATE TABLE IF NOT EXISTS idea_members (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    idea_id BIGINT NOT NULL
        REFERENCES posts(id),

    user_id BIGINT NOT NULL
        REFERENCES users(id),

    team_role VARCHAR(30) NOT NULL DEFAULT 'CONTRIBUTOR'
        CHECK (team_role IN (
            'OWNER',
            'TEAM_LEAD',
            'CONTRIBUTOR',
            'REVIEWER',
            'ADVISOR'
        )),

    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE (idea_id, user_id)
);