use std::collections::HashSet;

/// Tracks unclaimed refs so an observed fragment can remove only dependencies
/// introduced in its scope, without copying or revisiting nested scopes.
#[derive(Default)]
pub(crate) struct RefTracker {
    used: HashSet<String>,
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
        // Nested scopes have already drained their entries. Moving these keys
        // avoids cloning them again at every enclosing scope. Removing them from
        // `used` also lets a subsequent parent read establish its own dependency.
        for key in self.added.drain(start..) {
            self.used.remove(&key);
        }
        self.active_scopes -= 1;
    }

    pub(crate) fn into_unclaimed(self) -> HashSet<String> {
        self.used
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parent_read_after_nested_claim_keeps_its_dependency() {
        let mut refs = RefTracker::default();
        let nested = refs.begin_scope();
        refs.insert("Pet:1.name".into());
        refs.claim_since(nested);
        refs.insert("Pet:1.name".into());
        assert_eq!(refs.into_unclaimed(), HashSet::from(["Pet:1.name".into()]));
    }

    #[test]
    fn nested_claim_preserves_an_existing_parent_dependency() {
        let mut refs = RefTracker::default();
        refs.insert("Pet:1.name".into());
        let nested = refs.begin_scope();
        refs.insert("Pet:1.name".into());
        refs.insert("Pet:1.age".into());
        refs.claim_since(nested);
        assert_eq!(refs.into_unclaimed(), HashSet::from(["Pet:1.name".into()]));
    }

    #[test]
    fn nested_claims_are_removed_from_enclosing_scopes() {
        let mut refs = RefTracker::default();
        refs.insert("ROOT_QUERY.item".into());
        let outer = refs.begin_scope();
        refs.insert("Item:1.name".into());
        let inner = refs.begin_scope();
        for index in 0..1000 {
            refs.insert(format!("Pet:{index}.name"));
        }
        refs.claim_since(inner);
        assert_eq!(refs.added, ["Item:1.name"]);
        let sibling = refs.begin_scope();
        refs.insert("Pet:0.name".into());
        refs.claim_since(sibling);
        assert_eq!(refs.added, ["Item:1.name"]);
        refs.claim_since(outer);
        assert!(refs.added.is_empty());
        assert_eq!(
            refs.into_unclaimed(),
            HashSet::from(["ROOT_QUERY.item".into()])
        );
    }
}
