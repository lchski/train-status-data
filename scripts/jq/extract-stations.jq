[to_entries[] |
    {train: .key} + .value |
    label $out |
    .times[] |
        if .eta != "ARR" then break $out end | [
            .code,
            .station
        ]
] |
.[] |
@tsv