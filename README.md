motiondiner
===========

helping the hungry masses win the game of hide and seek with the food trucks

mysql setup
===========

    mysql -u root -p

    CREATE DATABASE motion_diner_development;
    CREATE DATABASE motion_diner_test;
    CREATE USER 'motion_diner'@'localhost' IDENTIFIED BY 'password';
    GRANT SELECT, CREATE, INSERT, UPDATE, DELETE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON motion_diner_development.* TO 'motion_diner'@'localhost';
    GRANT SELECT, CREATE, INSERT, UPDATE, DELETE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON motion_diner_test.* TO 'motion_diner'@'localhost';
    FLUSH PRIVILEGES;
