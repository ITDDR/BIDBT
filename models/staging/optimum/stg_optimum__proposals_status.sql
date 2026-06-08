with 

source as (

    select * from {{ source('optimum', 'proposals_status') }}

),

renamed as (

    select
        proposal_status_id,
        proposal_status_name,
        proposal_status_description,
        source_file_name,
        export_date

    from source

)

select * from renamed