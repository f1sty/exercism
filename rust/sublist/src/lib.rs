#[derive(Debug, PartialEq, Eq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

pub fn sublist<T: PartialEq>(first_list: &[T], second_list: &[T]) -> Comparison {
    if first_list == second_list {
        Comparison::Equal
    } else if first_list.len() > second_list.len() {
        let mut first_list = first_list.clone();
        let mut second_list = second_list.clone();
        let sublist_start_elem = second_list[0];
        let sublist_start_idx = second_list.iter().find(|&&elem| elem == sublist_start_elem).unwrap();
    }

}
