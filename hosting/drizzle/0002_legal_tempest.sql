CREATE TABLE `character_statistics` (
	`character_id` integer NOT NULL,
	`service` text NOT NULL,
	`sequence` text NOT NULL,
	`payload` text NOT NULL,
	`processed` integer DEFAULT 0 NOT NULL,
	PRIMARY KEY(`character_id`, `service`, `sequence`),
	FOREIGN KEY (`character_id`) REFERENCES `characters`(`id`) ON UPDATE no action ON DELETE no action
);
