use snforge_std::*;
use starknet::Felt252TryInto;
use starknet::ContractAddress;
use openzeppelin::access::ownable::OwnableComponent;

fn OWNER() -> ContractAddress {
    'OWNER'.try_into().unwrap()
}


#[deploy]
fn deploy_counter() -> CounterDispatcher {
    Counter::deploy(OWNER()).into_dispatcher()
}


#[test]
fn test_counter_initial_value() {
    let counter = deploy_counter();
    let count = counter.get_count();
    assert_eq!(count, 0);
}

#[test]
fn test_increment() {
    let counter = deploy_counter();
    counter.increment();
    let count = counter.get_count();
    assert_eq!(count, 1);
}
