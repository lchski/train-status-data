[to_entries[] |
    {train: .key} + .value |
    label $out |
    .train as $trainId |
    .times[] |
        if .eta != "ARR" then break $out end | {
            train: $trainId,
            code,
            scheduled,
            actual: .estimated
        }
]