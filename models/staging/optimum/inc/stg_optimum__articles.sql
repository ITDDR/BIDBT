with 

source as (

    select * from {{ source('optimum', 'articles') }}

)

select
    article_code,
    article_name as nom_article,
    shop_id as idMagasin,
    article_type_id,
    update_datetime,
    export_date
from source