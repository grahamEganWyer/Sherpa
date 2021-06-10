CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username TEXT,
    password_digest TEXT,
    user_level INTEGER,
    steps_completed INTEGER[]
);
