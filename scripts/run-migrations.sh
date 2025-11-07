#!/bin/bash
set -e

# ============================
#  Database migration runner
# ============================

DB_HOST=${DB_HOST:-db}
DB_USER=${DB_USER:-root}
DB_PASS=${DB_PASS:-root}
MIGRATIONS_DIR=${MIGRATIONS_DIR:-./data/database/migrations}

echo "Running migrations on host: $DB_HOST"
echo "Looking for SQL files in: $MIGRATIONS_DIR"

if [ ! -d "$MIGRATIONS_DIR" ]; then
  echo "Migrations directory not found: $MIGRATIONS_DIR"
  exit 1
fi

# Run each .sql file in natural version order
for file in $(find "$MIGRATIONS_DIR" -type f -name "*.sql" | sort -V); do
  filename=$(basename "$file")
  echo "Applying migration: $filename"
  mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" < "$file"
done

echo "All migrations completed successfully!"
