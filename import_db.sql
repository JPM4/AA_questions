CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  question_id INTEGER NOT NULL REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL REFERENCES users(id),
  question_id INTEGER NOT NULL REFERENCES questions(id),
  parent_id INTEGER REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  question_id INTEGER NOT NULL REFERENCES questions(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Josh', 'Trotter'), ('David', 'Lynch'), ('Oprah', 'Winfrey'),
  ('Gregg', 'Popovich');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('sky color?', 'Why is the sky blue?',
    (SELECT id FROM users WHERE lname = 'Trotter')),
  ('three-pointers?', 'How many three-pointers should a team shoot per game?',
    (SELECT id FROM users WHERE lname = 'Winfrey')),
  ('hot things?', 'Why do really hot things feel cold sometimes?',
    (SELECT id FROM users WHERE lname = 'Trotter'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (4, 2), (2, 1), (1, 1), (3, 2);

INSERT INTO
  replies (body, user_id, question_id, parent_id)
VALUES
  ('However many you can make.', 4, 2, NULL),
  ("I'd like to make a movie about basketball.", 2, 2, 1),
  ("Oh I just looked it up and the sky is blue because of the absorption
    frequency of gases in the atmosphere.", 1, 1, NULL),
  ("I'd like to see that movie!", 1, 2, 2);

INSERT INTO
  question_likes (user_id, question_id)
VALUES
  (1, 1), (1, 2), (2, 2), (3, 1), (3, 2);
