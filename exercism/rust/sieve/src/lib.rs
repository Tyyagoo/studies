pub fn primes_up_to(upper_bound: u64) -> Vec<u64> {
    let mut primes = (2..=upper_bound).map(|n| Some(n)).collect::<Vec<_>>();

    for x in 2..=upper_bound {
        primes = primes
            .iter()
            .filter_map(|n| (((*n)? < x * x) || (*n)? % x != 0).then_some(*n))
            .collect::<Vec<Option<u64>>>();
    }

    primes.iter().filter_map(|sn| *sn).collect::<Vec<u64>>()
}
