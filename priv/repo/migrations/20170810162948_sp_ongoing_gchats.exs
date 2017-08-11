defmodule Portal.Repo.Migrations.SpOngoingGchats do
  use Ecto.Migration

  def up do
    execute "
      CREATE PROCEDURE `sp_ongoing_gchats`(IN `uid` BIGINT)
      BEGIN
        DECLARE _username VARCHAR(255);
        DECLARE _counter_id, __counter_id BIGINT;
        DECLARE _rec_id BIGINT;
        DECLARE _read TINYINT;
        DECLARE _type VARCHAR(20);
        
        DROP TEMPORARY TABLE IF EXISTS temp_last_chats;
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_last_chats (
          counter_id BIGINT,
          rec_id BIGINT,
          `read` TINYINT,
          `type` VARCHAR(20)
        );
        
        BLOCK1: BEGIN
          DECLARE on_finished1 BIGINT;
          DECLARE cur1 CURSOR FOR SELECT DISTINCT(a.counter_id) AS 'counter_id' FROM daily_chats AS a WHERE a.user_id = uid AND a.`type` = 'P2G';
          DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished1 = 1;
          
          OPEN cur1;
          loop1 : LOOP
            FETCH cur1 INTO _counter_id;
            IF on_finished1 = 1 THEN
              LEAVE loop1;
            END IF;

            BLOCK2: BEGIN
              DECLARE on_finished2 BIGINT;
              DECLARE cur2 CURSOR FOR SELECT a.counter_id AS 'counter_id', a.id, a.`read`, a.`type` FROM daily_chats AS a WHERE a.counter_id = _counter_id AND a.user_id = uid AND a.`type` = 'P2G';
              DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished2 = 1;
              
              OPEN cur2;
              loop2 : LOOP
                FETCH cur2 INTO __counter_id, _rec_id, _read, _type;
                IF on_finished2 = 1 THEN
                  LEAVE loop2;
                END IF;
                
                INSERT INTO temp_last_chats(counter_id, rec_id, `read`, `type`) VALUES (__counter_id, _rec_id, _read, _type);
              END LOOP loop2;
              CLOSE cur2;
            END BLOCK2;
            
          END LOOP loop1;
          CLOSE cur1;
        END BLOCK1;
        
        SELECT * FROM temp_last_chats ORDER BY rec_id ASC;
      END
    "
  end
end
