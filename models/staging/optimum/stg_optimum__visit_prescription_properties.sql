with 

source as (

    select * from {{ source('optimum', 'visit_prescription_properties') }}

),

renamed as (

    select
        visit_id,
        prescriptor_id,
        seller_id,
        is_new,
        is_adapted,
        prescription_date,
        is_with_glass,
        is_with_lens,
        creation_datetime,
        update_datetime,
        glass_sphere_right,
        glass_cylindre_right,
        glass_axe_right,
        glass_addition_right,
        flat_glass_right,
        is_tinted_right,
        glass_prisme_1_dioptries_right,
        glass_prisme_1_base_right,
        glass_prisme_2_dioptries_right,
        glass_prisme_2_base_right,
        glass_sphere_left,
        glass_cylindre_left,
        glass_axe_left,
        glass_addition_left,
        flat_glass_left,
        is_tinted_left,
        lens_sphere_right,
        lens_cylindre_right,
        lens_axe_right,
        lens_addition_right,
        lens_sphere_left,
        lens_cylindre_left,
        lens_axe_left,
        lens_addition_left,
        glass_prisme_1_dioptries_left,
        glass_prisme_1_base_left,
        glass_prisme_2_dioptries_left,
        glass_prisme_2_base_left,
        is_prescription_centieme,
        glass_cylindre_centieme_right,
        glass_cylindre_centieme_left,
        glass_sphere_centieme_right,
        glass_sphere_centieme_left,
        prescription_medecin_sncf,
        source_file_name,
        export_date

    from source

)

select * from renamed