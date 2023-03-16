pub fn actions(n: u8) -> Vec<&'static str> {
    let all_actions = vec![
        (0x01, "wink"),
        (0x02, "double blink"),
        (0x04, "close your eyes"),
        (0x08, "jump"),
    ];

    let req_actions = all_actions
        .iter()
        .filter_map(|(code, act)| (*code & n > 0).then_some(*act));

    if let 0x10 = n & 0x10 {
        req_actions.rev().collect()
    } else {
        req_actions.collect()
    }
}
