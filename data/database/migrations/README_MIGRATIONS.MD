# Database Migrations Guidelines

This folder "database/migrations" contains all SQL migration files used to evolve the database schema
for all environments (local, test, and production).

Each file represents one schema change per database and must be idempotent,
meaning it can be safely re-run multiple times without breaking or duplicating data.

---

## Naming Convention

Use semantic versioning (SemVer) followed by a short description:

```
<Major>.<Minor>.<Patch>_<short_description>.sql
```

### Examples

```
0.0.1_init.sql
0.0.2_add_demo_table.sql
0.1.0_benchmarks_add_users_table.sql
0.1.1_signup_add_signup_table.sql
0.2.0_study_update_study_schema.sql

```

**Rules:**
- The initial migration (0.0.1_init.sql) may create tables for multiple databases (benchmarks, signup, study, etc.)
- For later migrations, keep the version number first and then the target database name (e.g. 0.1.0_benchmarks_...)
- Increment version numbers sequentially (0.0.1, 0.0.2, 0.1.0, etc.)
- Use only lowercase letters
- Separate words with underscores (_)
- Avoid spaces, special characters, or uppercase letters
- Each file should represent one logical change (one table or one structural update)

This approach keeps initialization scripts global and shared, while later migrations stay organized per database, maintaining a clear order and version control across all environments.

## SQL File Structure

Each SQL file should follow this format:

```sql
USE benchmarks;

-- Always make it idempotent
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100)
);

ALTER TABLE users ADD COLUMN IF NOT EXISTS email VARCHAR(255);
```

---

## How to Apply Migrations

### Locally

Run the migration runner script:

```bash
./scripts/run-migrations.sh
```

This will:

- in lexicographic (alphabetical) order, which matches version order when using SemVer filenames.

Because migrations are designed to be idempotent, you can safely re-run
the script even if you already have data and existing tables.

---

### In CI/CD (Test and Production)

The same script is automatically executed in the deployment pipeline (GitHub Actions)
after the new containers are deployed.

**Process summary:**

1. GitHub Actions pulls the latest image and code.
2. It runs `run-migrations.sh` on the target environment.
3. The script applies all .sql files in version order.
4. Databases remain synchronized across all environments, as the scripts are safe to re-run.

---

_Last updated: November 2025_
