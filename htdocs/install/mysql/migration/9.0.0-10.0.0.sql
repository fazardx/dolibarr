--
-- Be carefull to requests order.
-- This file must be loaded by calling /install/index.php page
-- when current version is 10.0.0 or higher.
--
-- To restrict request to Mysql version x.y minimum use -- VMYSQLx.y
-- To restrict request to Pgsql version x.y minimum use -- VPGSQLx.y
-- To rename a table:       ALTER TABLE llx_table RENAME TO llx_table_new;
-- To add a column:         ALTER TABLE llx_table ADD COLUMN newcol varchar(60) NOT NULL DEFAULT '0' AFTER existingcol;
-- To rename a column:      ALTER TABLE llx_table CHANGE COLUMN oldname newname varchar(60);
-- To drop a column:        ALTER TABLE llx_table DROP COLUMN oldname;
-- To change type of field: ALTER TABLE llx_table MODIFY COLUMN name varchar(60);
-- To drop a foreign key:   ALTER TABLE llx_table DROP FOREIGN KEY fk_name;
-- To create a unique index ALTER TABLE llx_table ADD UNIQUE INDEX uk_table_field (field);
-- To drop an index:        -- VMYSQL4.1 DROP INDEX nomindex on llx_table
-- To drop an index:        -- VPGSQL8.2 DROP INDEX nomindex
-- To make pk to be auto increment (mysql):    -- VMYSQL4.3 ALTER TABLE llx_table CHANGE COLUMN rowid rowid INTEGER NOT NULL AUTO_INCREMENT;
-- To make pk to be auto increment (postgres):
-- -- VPGSQL8.2 CREATE SEQUENCE llx_table_rowid_seq OWNED BY llx_table.rowid;
-- -- VPGSQL8.2 ALTER TABLE llx_table ADD PRIMARY KEY (rowid);
-- -- VPGSQL8.2 ALTER TABLE llx_table ALTER COLUMN rowid SET DEFAULT nextval('llx_table_rowid_seq');
-- -- VPGSQL8.2 SELECT setval('llx_table_rowid_seq', MAX(rowid)) FROM llx_table;
-- To set a field as NULL:                     -- VMYSQL4.3 ALTER TABLE llx_table MODIFY COLUMN name varchar(60) NULL;
-- To set a field as NULL:                     -- VPGSQL8.2 ALTER TABLE llx_table ALTER COLUMN name DROP NOT NULL;
-- To set a field as NOT NULL:                 -- VMYSQL4.3 ALTER TABLE llx_table MODIFY COLUMN name varchar(60) NOT NULL;
-- To set a field as NOT NULL:                 -- VPGSQL8.2 ALTER TABLE llx_table ALTER COLUMN name SET NOT NULL;
-- To set a field as default NULL:             -- VPGSQL8.2 ALTER TABLE llx_table ALTER COLUMN name SET DEFAULT NULL;
-- Note: fields with type BLOB/TEXT can't have default value.

-- Missing in 9.0

DROP TABLE llx_ticket_logs;

CREATE TABLE llx_pos_cash_fence(
	rowid INTEGER AUTO_INCREMENT PRIMARY KEY,
	entity INTEGER DEFAULT 1 NOT NULL,
	ref VARCHAR(64),
	label VARCHAR(255),
	opening double(24,8) default 0,
	cash double(24,8) default 0,
	card double(24,8) default 0,
	cheque double(24,8) default 0,
	status INTEGER,
	date_creation DATETIME NOT NULL,
	date_valid DATETIME,
	day_close INTEGER,
	month_close INTEGER,
	year_close INTEGER,
	posmodule VARCHAR(30),
	posnumber VARCHAR(30),
	fk_user_creat integer,
	fk_user_valid integer,
	tms TIMESTAMP NOT NULL,
	import_key VARCHAR(14)
) ENGINE=innodb;



-- For 10.0

ALTER TABLE llx_loan ADD COLUMN insurance_amount double(24,8) DEFAULT 0;

ALTER TABLE llx_facture DROP INDEX idx_facture_uk_facnumber;
ALTER TABLE llx_facture CHANGE facnumber ref VARCHAR(30) NOT NULL;
ALTER TABLE llx_facture ADD UNIQUE INDEX uk_facture_ref (ref, entity);

insert into llx_c_action_trigger (code,label,description,elementtype,rang) values ('TICKET_CREATE','Ticket created','Executed when a ticket is created','ticket',161);
insert into llx_c_action_trigger (code,label,description,elementtype,rang) values ('TICKET_MODIFY','Ticket modified','Executed when a ticket is modified','ticket',163);
insert into llx_c_action_trigger (code,label,description,elementtype,rang) values ('TICKET_DELETE','Ticket deleted','Executed when a ticket is deleted','ticket',164);

create table llx_mailing_unsubscribe
(
  rowid				integer AUTO_INCREMENT PRIMARY KEY,
  entity			integer DEFAULT 1 NOT NULL,	         -- multi company id
  email				varchar(255),
  unsubscribegroup	varchar(128) DEFAULT '',
  ip				varchar(128),
  date_creat		datetime,                            -- creation date
  tms               timestamp
)ENGINE=innodb;

ALTER TABLE llx_mailing_unsubscribe ADD UNIQUE uk_mailing_unsubscribe(email, entity, unsubscribegroup);

ALTER TABLE llx_adherent ADD gender VARCHAR(10);
ALTER TABLE llx_subscription ADD fk_type integer(11);

-- Add url_id into unique index of bank_url
ALTER TABLE llx_bank_url DROP INDEX uk_bank_url;
ALTER TABLE llx_bank_url ADD UNIQUE INDEX uk_bank_url (fk_bank, url_id, type);


ALTER TABLE llx_actioncomm ADD COLUMN calling_duration integer;


ALTER TABLE llx_don ADD COLUMN fk_soc integer NULL;

ALTER TABLE llx_payment_various ADD COLUMN subledger_account varchar(32);

CREATE TABLE llx_c_measuring_units(
	rowid integer AUTO_INCREMENT PRIMARY KEY,
	code varchar(3),
	label varchar(50),
	short_label varchar(5),
	unit_type varchar(10),
	active tinyint DEFAULT 1 NOT NULL
) ENGINE=innodb;

ALTER TABLE llx_c_measuring_units ADD UNIQUE uk_c_measuring_units_code(code,unit_type);

INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('3','WeightUnitton','T', 'weight', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('0','WeightUnitkg','Kg', 'weight', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-3','WeightUnitg','g', 'weight', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-6','WeightUnitmg','g', 'weight', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('98','WeightUnitounce','Oz', 'weight', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('99','WeightUnitpound','lb', 'weight', 1);

INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('0','SizeUnitm','m', 'size', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-1','SizeUnitdm','dm', 'size', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-2','SizeUnitcm','cm', 'size', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-3','SizeUnitmm','mm', 'size', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('98','SizeUnitfoot','ft', 'size', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('99','SizeUnitinch','in', 'size', 1);

INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('0','SurfaceUnitm2','m2', 'surface', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-2','SurfaceUnitdm2','dm2', 'surface', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-4','SurfaceUnitcm2','cm2', 'surface', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-6','SurfaceUnitmm2','mm2', 'surface', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('98','SurfaceUnitfoot2','ft2', 'surface', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('99','SurfaceUnitinch2','in2', 'surface', 1);

INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('0','VolumeUnitm3','m3', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-3','VolumeUnitdm3','dm3', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-6','VolumeUnitcm3','cm3', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('-9','VolumeUnitmm3','mm3', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('88','VolumeUnitfoot3','ft3', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('89','VolumeUnitinch3','in3', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('97','VolumeUnitounce','Oz', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('98','VolumeUnitlitre','L', 'volume', 1);
INSERT INTO llx_c_measuring_units (code, label, short_label, unit_type, active) VALUES ('99','VolumeUnitgallon','gal', 'volume', 1);
