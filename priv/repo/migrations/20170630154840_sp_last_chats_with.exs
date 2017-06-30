defmodule Portal.Repo.Migrations.SpLastChatsWith do
  use Ecto.Migration

  def up do
    execute "CREATE PROCEDURE `sp_last_chats_with`(IN `uid` BIGINT, IN `fid` BIGINT)
    BEGIN
      DECLARE n1, n2 INT;
      
      SELECT COUNT(*) INTO n1 FROM daily_chats AS a WHERE a.updated_at = (SELECT MAX(a.updated_at) FROM daily_chats AS a WHERE a.user_a_id = uid AND a.user_b_id = fid);
      SELECT COUNT(*) INTO n2 FROM daily_chats AS a WHERE a.updated_at = (SELECT MAX(a.updated_at) FROM daily_chats AS a WHERE a.user_b_id = uid AND a.user_a_id = fid);
      
      IF n1 = 1 THEN
        SELECT a.messages FROM daily_chats AS a WHERE a.updated_at = (SELECT MAX(a.updated_at) FROM daily_chats AS a WHERE a.user_a_id = uid AND a.user_b_id = fid);
      END IF;
      
      IF n2 = 1 THEN
        SELECT a.messages FROM daily_chats AS a WHERE a.updated_at = (SELECT MAX(a.updated_at) FROM daily_chats AS a WHERE a.user_b_id = uid AND a.user_a_id = fid);
      END IF;
    END"
  end

  def down do
    execute "DROP PROCEDURE IF EXISTS `sp_last_chats_with`;"
  end
end
