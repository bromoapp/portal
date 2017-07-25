defmodule Portal.Repo.Migrations.SpIsInvitExists do
  use Ecto.Migration

  def up do
    execute "
      CREATE PROCEDURE `sp_is_invit_exists`(IN `user_a_id` BIGINT, IN `user_b_id` BIGINT)
      BEGIN
        DECLARE total INT DEFAULT 0;
        SELECT COUNT(*) INTO total FROM invitations AS a WHERE a.from_id = user_a_id AND a.to_id = user_b_id;
        IF total = 0 THEN
          SELECT COUNT(*) INTO total FROM invitations AS a WHERE a.from_id = user_b_id AND a.to_id = user_a_id;
        END IF;
        SELECT total;
      END
    "
  end
end
