use std::collections::HashSet;

/// Tracks the first occurrence of each ref so an observed fragment can claim
/// only refs added while visiting that fragment, without copying the whole set.
#[derive(Default)]
pub(crate) struct RefTracker {
    used: HashSet<String>,
    claimed: HashSet<String>,
    added: Vec<String>,
    active_scopes: usize,
}

impl RefTracker {
    pub(crate) fn insert(&mut self, key: String) {
        if self.active_scopes == 0 {
            self.used.insert(key);
        } else if self.used.insert(key.clone()) {
            self.added.push(key);
        }
    }

    pub(crate) fn begin_scope(&mut self) -> usize {
        self.active_scopes += 1;
        self.added.len()
    }

    pub(crate) fn claim_since(&mut self, start: usize) {
        for key in &self.added[start..] {
            self.claimed.insert(key.clone());
        }
        self.active_scopes -= 1;
        if self.active_scopes == 0 {
            self.added.clear();
        }
    }

    pub(crate) fn into_unclaimed(self) -> HashSet<String> {
        self.used.difference(&self.claimed).cloned().collect()
    }
}
