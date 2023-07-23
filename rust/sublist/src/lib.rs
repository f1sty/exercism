#[derive(Debug, PartialEq, Eq)]
pub enum Comparison {
    Equal,
    Sublist,
    Superlist,
    Unequal,
}

pub fn sublist<T: PartialEq>(first_list: &[T], second_list: &[T]) -> Comparison {
    let first_list_len = first_list.len();
    let second_list_len = second_list.len();

    if first_list_len > second_list_len && is_sublist(first_list, second_list, second_list_len) {
        Comparison::Superlist
    } else if first_list_len < second_list_len
        && is_sublist(second_list, first_list, first_list_len)
    {
        Comparison::Sublist
    } else if first_list == second_list {
        Comparison::Equal
    } else {
        Comparison::Unequal
    }
}

fn is_sublist<T: PartialEq>(bigger_list: &[T], smaller_list: &[T], window_size: usize) -> bool {
    if bigger_list.is_empty() || smaller_list.is_empty() {
        return true;
    }
    bigger_list
        .windows(window_size)
        .any(|window| window == smaller_list)
}
