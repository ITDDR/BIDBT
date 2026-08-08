with source as (
    select * from {{ source('optimum', 'articles_types') }}
)

select
    article_type_id
from source