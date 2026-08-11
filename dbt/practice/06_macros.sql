-- macros/
--     calculate_tax.sql

{% macro calculate_tax(amount, tax_rate) %}
    ({{ amount }} * {{ tax_rate }} / 100)
{% endmacro %}

-------------------------------------------------------------

SELECT
    order_id,
    amount,
    {{ calculate_tax('amount', 18) }} AS tax_amount
FROM {{ ref('orders') }}