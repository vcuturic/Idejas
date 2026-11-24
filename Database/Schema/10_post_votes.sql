CREATE TABLE IF NOT EXISTS post_votes (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    post_id BIGINT NOT NULL
        REFERENCES posts(id),

    user_id BIGINT NOT NULL
        REFERENCES users(id),

    vote_type VARCHAR(10) NOT NULL
        CHECK (vote_type IN ('LIKE', 'DISLIKE')),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT unique_user_post_vote
        UNIQUE (post_id, user_id)
);