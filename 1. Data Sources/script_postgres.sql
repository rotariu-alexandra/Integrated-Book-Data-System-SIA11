CREATE TABLE users (
    user_id INT PRIMARY KEY,
    location TEXT,
    age INT
);
ALTER TABLE users ALTER COLUMN age TYPE TEXT;

-- 2. Tabelul de Tematici (Catalogul)
CREATE TABLE themes (
    theme_id SERIAL PRIMARY KEY,
    theme_name VARCHAR(100) UNIQUE
);

-- 3. Tabelul de legătură (Cui ce îi place)
CREATE TABLE user_interests (
    user_id INT,
    theme_id INT,
    CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(user_id),
    CONSTRAINT fk_theme FOREIGN KEY(theme_id) REFERENCES themes(theme_id),
    PRIMARY KEY (user_id, theme_id)
);


CREATE TABLE staging_books (
    book_title TEXT,
    book_author TEXT,
    user_id INT,
    isbn TEXT,
    book_rating INT,
    year_of_publication TEXT,
    publisher TEXT,
    location TEXT,
    age TEXT, -- Uneori vârsta are puncte/nule, e mai sigur TEXT aici
    category TEXT,
    description TEXT,
    num_words TEXT,
    num_chars TEXT,
    cleaned_description TEXT,
    theme_name TEXT -- Asta e coloana finală "Theme" din poza ta
);

--inserare
INSERT INTO themes (theme_name)
SELECT DISTINCT theme_name 
FROM staging_books 
WHERE theme_name IS NOT NULL AND theme_name <> ''
ON CONFLICT (theme_name) DO NOTHING;

INSERT INTO user_interests (user_id, theme_id)
SELECT DISTINCT s.user_id, t.theme_id
FROM staging_books s
JOIN themes t ON s.theme_name = t.theme_name
WHERE s.user_id IS NOT NULL
ON CONFLICT DO NOTHING;

--testare
SELECT t.theme_name, COUNT(ui.user_id) as numar_utilizatori
FROM themes t
JOIN user_interests ui ON t.theme_id = ui.theme_id
GROUP BY t.theme_name
ORDER BY numar_utilizatori DESC;

--curatare
DROP TABLE staging_books;