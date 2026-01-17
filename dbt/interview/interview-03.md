#### Q-1 How would you manage dbt deployment across multiple environments (dev, staging, production)?
```bash
1. Environment-specific configurations

models:
  my_project:
    dev:
      schema: dev_schema
    staging:
      schema: staging_schema
    prod:
      schema: prod_schema

dbt automatically selects the correct schema based on the target environment (dev, staging, or prod) 
when running the project.

2. Using the target variable

{% if target.name == 'prod' %}
    SELECT * FROM production_table
{% else %}
    SELECT * FROM {{ ref('staging_table') }}
{% endif %}

3. Branching and Version Control

4. Continuous Integration (CI) & Continuous Deployment (CD)
```

#### Q-2 You’re tasked with creating a DBT model that integrates data from different sources, each with different update frequencies (e.g., daily and weekly updates). How would you structure your DBT models to handle these differences effectively ? 
```bash
Once the staging models are established, create a transformation model that combines the data. This model 
should be designed to accommodate the varying data update frequencies. Implementing incremental models can 
enhance efficiency, allowing DBT to only process the new or changed records based on the update frequency.
```

#### Q-3 Command for Project Setup & Basics ?
```bash
1. dbt init
Creates a new dbt project with starter folders and config files.

2. dbt debug
Checks if dbt can connect to your data warehouse and validates profiles.yml.

3. dbt deps
Installs packages listed in packages.yml.

4. dbt clean
Removes target/, dbt_packages/, and other generated files.

5. dbt --version
Shows the installed dbt version and adapter info.
```

#### Q-4 Command for Running Models ?
```bash
1. dbt run
Runs all models in the project.

2. dbt run --select model_name
Runs a specific model.
```

#### Q-5 command for Runs a model and its upstream & downstream dependents ?
```bash
1. dbt run --select +model_name
Runs a model and its upstream dependencies.

2. dbt run --select model_name+
Runs a model and its downstream dependents.

3. dbt run --select +model_name+
Runs a model, its parents, and children.
```

#### Q-6 Runs a model specified , specific tag. ? 
```bash
dbt run --exclude model_name
Runs all models except the specified one.

dbt run --select tag:finance
Runs models with a specific tag.

dbt run --select path:models/staging
Runs models in a specific folder.

dbt run --select state:modified
Runs only models that changed since last run.
```

#### Q-7 command for Testing & Validation ? 
```bash
dbt test
Runs all tests (schema + data tests).

dbt test --select model_name
Runs tests for a specific model.

dbt test --select test_type:singular
Runs only singular tests.

dbt test --select test_type:generic
Runs only generic schema tests.

dbt test --store-failures
Stores failing test rows in the warehouse.
```

#### Q-8 command for Seeds & Snapshots ? 
```bash
dbt seed
Loads CSV files from the seeds/ directory into the warehouse.

dbt seed --full-refresh
Reloads all seed data from scratch.

dbt snapshot
Runs snapshot logic to track slowly changing dimensions.
```

#### Q-9 command for Documentation ? 
```bash
dbt docs generate
Generates documentation artifacts.

dbt docs serve
Serves dbt docs locally in a web browser.
```

#### Q-10 command for Refresh & Rebuild ? 
```bash
dbt run --full-refresh
Drops and rebuilds incremental models.

dbt build
Runs models + tests + seeds + snapshots together.

dbt build --select model_name
Builds a specific model and its tests.
```

#### Q-11 Runs models that depend on a specific source ? 
```bash
dbt run --select source:raw.sales
```

#### Q-12 Runs only table-materialized models. ?
```bash
dbt run --select config.materialized:table
```

#### Q-13 Runs models related to an exposure. ? 
```bash
dbt run --select exposure:dashboard_name
```

#### Q-14 Runs models from a specific package ? 
```bash
dbt run --select package:my_package
```

#### Q-15 Lists models, tests, sources, etc ? 
```bash
dbt ls
```

#### Q-16 Lists only models ?
```bash
dbt ls --resource-type model
```

#### Q-17 Lists resources with a specific tag ? 
```bash
dbt ls --select tag:core
```

#### Q-18 Debugging & Performance
```bash
dbt compile
Compiles SQL without running it (great for debugging).

dbt parse
Parses project files and validates structure.
```

#### Q-19 Runs models using multiple threads for speed.? 
```bash
dbt run --threads 8
Runs models using multiple threads for speed.

dbt run --fail-fast
Stops execution immediately when a model fails.
```

#### Q-20 State & CI/CD Use Cases ? 
```bash
dbt build --select state:modified+
Builds only modified models and their dependencies.

dbt run --defer --state prod_artifacts/
Uses production artifacts to avoid rebuilding unchanged models (CI/CD magic ✨).
```