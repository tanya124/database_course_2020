DELIMITER //
CREATE PROCEDURE Melnikova.CREATE_USERS(IN count INT)
BEGIN
    DECLARE i INT;
    SET i = 0;
    REPEAT
        insert into Melnikova.USER(user_id, name)
        values (i, CONCAT('user_name_', i));
        set i = i + 1;
    until i = count end repeat;
END;
//

DELIMITER //
CREATE PROCEDURE Melnikova.CREATE_PLAYLISTS(IN count INT)
BEGIN
    DECLARE i INT;
    SET i = 0;
    REPEAT
        insert into Melnikova.PLAYLIST(PLAYLIST_ID, TITLE, DESCRIPTION)
        values (i, CONCAT('title_', i), CONCAT('description_', i));
        set i = i + 1;
    until i = count end repeat;
END;
//

DELIMITER //
CREATE PROCEDURE Melnikova.CREATE_USER_X_PLAYLIST(IN count INT)
BEGIN
    DECLARE i INT;
    SET i = 0;
    REPEAT
        insert into Melnikova.USER_X_PLAYLIST(USER_ID, PLAYLIST_ID)
        values (i, count - 1 - i);
        set i = i + 1;
    until i = count end repeat;
END;
//

CALL Melnikova.CREATE_USERS(100);
CALL Melnikova.CREATE_PLAYLISTS(100);
CALL Melnikova.CREATE_USER_X_PLAYLIST(100);



LOAD DATA INFILE '/var/lib/mysql-files/albums.csv' INTO TABLE Melnikova.ALBUM
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';

LOAD DATA INFILE '/var/lib/mysql-files/artists.csv' INTO TABLE Melnikova.ARTIST
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';

LOAD DATA INFILE '/var/lib/mysql-files/tracks.csv' INTO TABLE Melnikova.TRACK
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';

LOAD DATA INFILE '/var/lib/mysql-files/album_x_track.csv' INTO TABLE Melnikova.ALBUM_X_TRACK
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';

LOAD DATA INFILE '/var/lib/mysql-files/artist_x_album.csv' INTO TABLE Melnikova.ARTIST_X_ALBUM
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';

LOAD DATA INFILE '/var/lib/mysql-files/artist_x_track.csv' INTO TABLE Melnikova.TRACK_X_ARTIST
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';

LOAD DATA INFILE '/var/lib/mysql-files/data_track_x_playlist.csv' INTO TABLE Melnikova.PLAYLIST_X_TRACK
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';

LOAD DATA INFILE '/var/lib/mysql-files/user_x_track.csv' INTO TABLE Melnikova.USER_X_TRACK
FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n';
