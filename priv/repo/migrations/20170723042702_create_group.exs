defmodule Portal.Repo.Migrations.CreateGroup do
  use Ecto.Migration

  def up do
    execute "
      CREATE TABLE `groups` (
        `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
        `name` VARCHAR(255) NULL DEFAULT NULL,
        `members` LONGTEXT NULL,
        `admins` VARCHAR(255) NULL DEFAULT NULL,
        `inserted_at` DATETIME NOT NULL,
        `updated_at` DATETIME NOT NULL,
        PRIMARY KEY (`id`),
        UNIQUE INDEX `id` (`id`)
      )
      COLLATE='utf8_general_ci'
      ENGINE=InnoDB
      ;"
  end
end
