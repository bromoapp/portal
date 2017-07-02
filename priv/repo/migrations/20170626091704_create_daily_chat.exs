defmodule Portal.Repo.Migrations.CreateDailyChat do
  use Ecto.Migration

  def up do
    execute "
      CREATE TABLE `daily_chats` (
        `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
        `read` TINYINT(1) NULL DEFAULT '1',
        `messages` LONGTEXT NULL,
        `user_a_id` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
        `user_b_id` BIGINT(20) UNSIGNED NULL DEFAULT NULL,
        `inserted_at` DATETIME NOT NULL,
        `updated_at` DATETIME NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE INDEX `id` (`id`),
        INDEX `daily_chats_user_a_id_fkey` (`user_a_id`),
        INDEX `daily_chats_user_b_id_fkey` (`user_b_id`),
        CONSTRAINT `daily_chats_user_a_id_fkey` FOREIGN KEY (`user_a_id`) REFERENCES `users` (`id`),
        CONSTRAINT `daily_chats_user_b_id_fkey` FOREIGN KEY (`user_b_id`) REFERENCES `users` (`id`)
      )
      COLLATE='utf8_general_ci'
      ENGINE=InnoDB
      ;"
  end
  
end
