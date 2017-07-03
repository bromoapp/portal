defmodule Portal.Repo.Migrations.SpLastChats do
  use Ecto.Migration

  def up do
    execute "
      CREATE PROCEDURE `sp_ongoing_chats`(IN `uid` BIGINT)
      BEGIN
        DECLARE _username VARCHAR(255);
        DECLARE _friend_id, __friend_id BIGINT;
        DECLARE _rec_id BIGINT;
        
        DROP TEMPORARY TABLE IF EXISTS temp_last_chats;
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_last_chats (
          friend_id BIGINT,
          rec_id BIGINT
        );
        
        BLOCK1: BEGIN
          DECLARE on_finished1 BIGINT;
          DECLARE cur0 CURSOR FOR SELECT DISTINCT(a.user_a_id) AS 'friend_id' FROM daily_chats AS a WHERE a.user_b_id = uid AND a.user_a_id != uid;
          DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished1 = 1;
          
          OPEN cur0;
          loop1 : LOOP
            FETCH cur0 INTO _friend_id;
            IF on_finished1 = 1 THEN
              LEAVE loop1;
            END IF;
            
            BLOCK2: BEGIN
              DECLARE on_finished2 BIGINT;
              DECLARE cur1 CURSOR FOR SELECT a.user_a_id AS 'friend_id', a.id FROM daily_chats AS a WHERE a.user_a_id = _friend_id AND a.user_b_id = uid;
              DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished2 = 1;
              
              OPEN cur1;
              loop2 : LOOP
                FETCH cur1 INTO __friend_id, _rec_id;
                IF on_finished2 = 1 THEN
                  LEAVE loop2;
                END IF;
                            
                INSERT INTO temp_last_chats(friend_id, rec_id) VALUES (__friend_id, _rec_id);
              END LOOP loop2;
              CLOSE cur1;
            END BLOCK2;
            
          END LOOP loop1;
          CLOSE cur0;
        END BLOCK1;
        
        BLOCK3: BEGIN
          DECLARE on_finished3 BIGINT;
          DECLARE cur2 CURSOR FOR SELECT DISTINCT(a.user_b_id) AS 'friend_id' FROM daily_chats AS a WHERE a.user_a_id = uid AND a.user_b_id != uid;
          DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished3 = 1;
          
          OPEN cur2;
          loop3 : LOOP
            FETCH cur2 INTO _friend_id;
            IF on_finished3 = 1 THEN
              LEAVE loop3;
            END IF;

            BLOCK4: BEGIN
              DECLARE on_finished4 BIGINT;
              DECLARE cur3 CURSOR FOR SELECT a.user_b_id AS 'friend_id', a.id FROM daily_chats AS a WHERE a.user_b_id = _friend_id AND a.user_a_id = uid;
              DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished4 = 1;
              
              OPEN cur3;
              loop4 : LOOP
                FETCH cur3 INTO __friend_id, _rec_id;
                IF on_finished4 = 1 THEN
                  LEAVE loop4;
                END IF;
                
                INSERT INTO temp_last_chats(friend_id, rec_id) VALUES (__friend_id, _rec_id);
              END LOOP loop4;
              CLOSE cur3;
            END BLOCK4;
            
          END LOOP loop3;
          CLOSE cur2;
        END BLOCK3;
        
        SELECT * FROM temp_last_chats ORDER BY rec_id ASC;
      END
    "
  end

  def down do
    execute "DROP PROCEDURE IF EXISTS `sp_ongoing_chats`;"
  end
end
