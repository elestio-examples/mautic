<?php
$_SERVER['HTTPS'] = 'on';
$parameters = array(
    'db_driver' => 'pdo_mysql',
    'db_host' => 'db',
    'db_port' => '3306',
    'db_name' => 'mautic_db',
    'db_user' => 'mautic_db_user',
    'db_password' => 'your-password',
    'db_table_prefix' => null,
    'db_backup_tables' => 1,
    'db_backup_prefix' => 'bak_',
);