with 

source as (

    select * from {{ source('optimum', 'proposals_status') }}

),

renamed as (

    select
        proposal_status_id,
        proposal_status_name,
        proposal_status_description

    from source

)

select * from renamed