with source as (

    select *
    from {{ ref('stg_optimum__clients') }}

),

ranked as (

    select
        client_id,
        code_postal,
        ville,
        pays,

        row_number() over (
            partition by client_id
            order by update_datetime desc
        ) as row_num

    from source

)

select
   client_id,
        code_postal,
        ville,
        pays
from ranked
where row_num = 1
