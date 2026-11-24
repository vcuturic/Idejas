CREATE TABLE Users (
	id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	username VARCHAR(50) NOT NULL UNIQUE
);

/* 
ALTER TABLE Users ADD COLUMN display_name VARCHAR(50);
COMMENT ON TABLE users IS 'Stores registered platform users';
COMMENT ON COLUMN users.username IS 'Unique public username';
UPDATE Users SET display_name = 'pretender-backender' WHERE username = 'vcuturic99';
DROP TABLE Users;
INSERT INTO Users (username) VALUES ('vcuturic99');
*/

SELECT * FROM users;

