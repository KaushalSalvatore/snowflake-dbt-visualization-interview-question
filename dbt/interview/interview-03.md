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

#### Q-3
```bash
```

#### Q-4
```bash
```

#### Q-5
```bash
```

#### Q-6
```bash
```

#### Q-7
```bash
```

#### Q-8
```bash
```

#### Q-9
```bash
```

#### Q-10
```bash
```

#### Q-11
```bash
```

#### Q-12
```bash
```

#### Q-13
```bash
```

#### Q-14
```bash
```

#### Q-15
```bash
```

#### Q-16
```bash
```

#### Q-17
```bash
```

#### Q-18
```bash
```

#### Q-19
```bash
```

#### Q-20
```bash
```