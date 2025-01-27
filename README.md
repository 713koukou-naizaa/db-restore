# db-restore

## Overview
`db-restore` is a bash script that makes restoring a database using `mariadb` easier. It was originally made to restore the database of [Comus Party](https://github.com/ValbionGroup/Comus-Party) easily.

## Features
- Drops the current database if it exists.
- Creates a new database using `mariadb`.
- Restores a database using `mariadb`.
- Logs the restore process to a .log file.

## Installation
1. Ensure these packages are installed:
    - `mariadb`
    - `mariadb-client`

2. Clone the repository:
   ```bash
   git clone https://github.com/713koukou-naizaa/db-restore.git
   cd db-restore

3. Make the script executable:
   ```bash
   chmod +x db-restore.sh