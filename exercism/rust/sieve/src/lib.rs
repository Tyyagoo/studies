pub fn primes_up_to(upper_bound: u64) -> Vec<u64> {
    let mut primes: Vec<_> = (2..=upper_bound).map(|x| Some(x)).collect();

    for curr in 2..=upper_bound {
        if let Some(None) = primes.get((curr - 2) as usize) {
            continue;
        }

        let idx = (curr * curr) - 2;
        for x in (idx..=(upper_bound - 2)).step_by(curr as usize) {
            primes[x as usize] = None;
        }
    }

    primes.iter().filter_map(|no| *no).collect()
}
