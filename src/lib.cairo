#[starknet::interface]
pub trait ICounter<TContractState> {
    fn get_counter(self: @TContractState) -> u32;
    fn increase_counter(ref self: TContractState);
    fn decrease_counter(ref self: TContractState);
    fn reset_counter(ref self: TContractState);
}

#[starknet::contract]
pub mod counter {
    use super::ICounter;
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    

    #[storage]
    pub struct Storage {
        counter: u32,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        Increase { account: ContractAddress, new_value: u32 },
        Decrease { account: ContractAddress, new_value: u32 },
        Reset { account: ContractAddress },
    }

    #[constructor]
    fn constructor(ref self: ContractState, init_value: u32) {
        self.counter.write(init_value);
    }

    #[abi(embed_v0)]
    impl CounterImpl of ICounter<ContractState> {
        fn get_counter(self: @ContractState) -> u32 {
            self.counter.read()
        }

        fn increase_counter(ref self: ContractState) {
            let new_value = self.counter.read() + 1;
            self.counter.write(new_value);
            self.emit(Event::Increase {
                account: get_caller_address(),
                new_value,
            });
        }

        fn decrease_counter(ref self: ContractState) {
            let new_value = self.counter.read() - 1;
            self.counter.write(new_value);
            self.emit(Event::Decrease {
                account: get_caller_address(),
                new_value,
            });
        }

        fn reset_counter(ref self: ContractState) {
            self.counter.write(0);
            self.emit(Event::Reset {
                account: get_caller_address(),
            });
        }
    }
}
