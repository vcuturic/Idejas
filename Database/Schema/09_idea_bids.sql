CREATE TABLE IF NOT EXISTS idea_bids (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    listing_id BIGINT NOT NULL
        REFERENCES idea_listings(id),

    bidder_id BIGINT NOT NULL
        REFERENCES users(id),

    amount NUMERIC(12, 2) NOT NULL
        CHECK (amount > 0),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);