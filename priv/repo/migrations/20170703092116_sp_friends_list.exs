defmodule Portal.Repo.Migrations.SpFriendsList do
  use Ecto.Migration

  def up do
    execute "
      CREATE PROCEDURE `sp_friends_list`(IN `uid` BIGINT)
      BEGIN
        DECLARE _id, __id, on_finished1, on_finished2 BIGINT;
        DECLARE _username, _name VARCHAR(255);

        DROP TEMPORARY TABLE IF EXISTS temp_friends;
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_friends (
          id BIGINT,
          name VARCHAR(255),
          username VARCHAR(255)
        );
        
        BLOCK1: BEGIN
          DECLARE cur0 CURSOR FOR SELECT a.user_b_id AS 'id' FROM relations AS a WHERE a.user_a_id = uid;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished1 = 1;
            
            OPEN cur0;
            loop1 : LOOP
              FETCH cur0 INTO _id;
              IF on_finished1 = 1 THEN
                LEAVE loop1;
              END IF;
              
              SELECT id, name, username INTO __id, _name, _username FROM users WHERE id = _id;
              INSERT INTO temp_friends(id, name, username) VALUES (__id, _name, _username);
          END LOOP loop1;
            CLOSE cur0;
        END BLOCK1;
        
        BLOCK2: BEGIN
          DECLARE cur1 CURSOR FOR SELECT a.user_a_id AS 'id' FROM relations AS a WHERE a.user_b_id = uid;
            DECLARE CONTINUE HANDLER FOR NOT FOUND SET on_finished2 = 1;
            
            OPEN cur1;
            loop1 : LOOP
              FETCH cur1 INTO _id;
              IF on_finished2 = 1 THEN
                LEAVE loop1;
              END IF;
              
              SELECT id, name, username INTO __id, _name, _username FROM users WHERE id = _id;
              INSERT INTO temp_friends(id, name, username) VALUES (__id, _name, _username);
          END LOOP loop1;
            CLOSE cur1;
        END BLOCK2;
        
        SELECT * FROM temp_friends;
      END
    "
  end

  def down do
    execute "DROP PROCEDURE IF EXISTS `sp_friends_list`;"
  end
end
