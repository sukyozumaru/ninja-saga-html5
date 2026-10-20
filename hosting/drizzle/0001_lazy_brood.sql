CREATE TABLE `characters` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`account_id` integer NOT NULL,
	`fingerprint` text NOT NULL,
	`profile` text NOT NULL,
	`created` integer NOT NULL,
	FOREIGN KEY (`account_id`) REFERENCES `accounts`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `characters_account_id_unique` ON `characters` (`account_id`);--> statement-breakpoint
ALTER TABLE `sessions` ADD `selected_character_id` integer;--> statement-breakpoint
ALTER TABLE `sessions` ADD `pending_skill` text;--> statement-breakpoint
ALTER TABLE `sessions` ADD `fresh_character` integer DEFAULT 0 NOT NULL;