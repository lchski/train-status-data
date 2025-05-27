[to_entries[] |
    {train: .key} + .value |
    label $out |
    .train as $trainId |
    .times[] |
        if .eta != "ARR" then break $out end | [
            $trainId,
            .code,
            .scheduled,
            .estimated
        ]
] |
.[] |
@tsv