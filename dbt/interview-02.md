#### Q-1 How DBT is used to integrate with other data tools ?
```bash
Data Warehouses: Integrate with popular data warehouses like Snowflake, BigQuery, Redshift.
BI Tools: Use the clean, transformed data in BI tools like Looker, Tableau.
Data Lakes: Connect to and transform data in data lakes.
```

#### Q-2 How DBT is used to automate your data workflow ?
```bash
Scheduled Runs: Schedule DBT runs using tools like Air flow or DBT Cloud.
CI/CD Integration: Integrate DBT with CI/CD pipelines for automated testing and deployment.
Modular Design: Create reusable, modular models to simplify maintenance and automation.
```

#### Q-3 What are ephemeral models in DBT ?
```bash
In dbt, ephemeral models are not directly built in the database. Rather, their code is inserted into the 
dependent models as common table expressions (CTEs). This ways it helps to keep the data warehouse clean 
and simple by reducing the clutter and allows for reusable logic. But still they can’t be selected directly.
```

#### Q-4 Can we split models across multiple schemas ?
```bash
Yes, we can.By usingvthe schema configuration in your DBT_project.yml file or by using a config block 
in the model file. For example: ‘schema: marketing.
```

#### Q-5 Do model names must be unique ? 
```bash
Yes because, dependencies between models are built using the ref function.And it only takes the model 
name as an argument. So, models even in distinct folders must have unique names.
```

#### Q-6 Explain the differences between DBT’s compile, run, and test phases ? 
```bash
Compile: DBT processes the Jinja templates and compiles them into SQL queries. This is a preparatory step 
before execution.
Run: DBT executes the compiled SQL queries against the target database, creating models (tables or views).

Test: DBT validates data by running assertions to ensure quality and consistency, such as checking for uniqueness, 
null values, or referential integrity.
```

#### Q-7 What is the purpose of DBT’s manifest file ? 
```bash
The manifest.json file contains metadata about the DBT project, including model dependencies, execution paths, 
configurations, and documentation. It helps DBT understand the lineage and structure of the models, improving 
dependency management and troubleshooting.
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