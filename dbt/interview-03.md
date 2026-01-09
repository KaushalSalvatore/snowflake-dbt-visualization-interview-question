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

#### Q-2
```bash
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