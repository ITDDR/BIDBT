with source as (
    select * from {{ source('optimum', 'articles_types') }}
)

select
    article_type_id,
    name as article_type_name
from source