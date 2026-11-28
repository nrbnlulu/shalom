//! The clock, timers and background tasks, which browsers provide differently.

#[cfg(not(target_family = "wasm"))]
mod imp {
    use std::future::Future;
    use std::time::Duration;

    pub(crate) use std::time::Instant;
    pub(crate) use tokio::time::sleep;

    pub(crate) fn spawn(task: impl Future<Output = ()> + Send + 'static) {
        tokio::spawn(task);
    }

    /// Calls `tick` every `interval` until it returns `false`. Uses a plain OS
    /// thread so it runs regardless of whether a Tokio runtime is active (e.g.
    /// during synchronous FRB init).
    pub(crate) fn repeat(interval: Duration, mut tick: impl FnMut() -> bool + Send + 'static) {
        std::thread::spawn(move || {
            loop {
                std::thread::sleep(interval);
                if !tick() {
                    break;
                }
            }
        });
    }
}

/// Browsers have no threads or Tokio timer here, so everything runs on the
/// JavaScript event loop.
#[cfg(target_family = "wasm")]
mod imp {
    use std::future::Future;
    use std::time::Duration;

    pub(crate) use gloo_timers::future::sleep;
    pub(crate) use web_time::Instant;

    pub(crate) fn spawn(task: impl Future<Output = ()> + 'static) {
        wasm_bindgen_futures::spawn_local(task);
    }

    /// Calls `tick` every `interval` until it returns `false`.
    pub(crate) fn repeat(interval: Duration, mut tick: impl FnMut() -> bool + 'static) {
        spawn(async move {
            loop {
                sleep(interval).await;
                if !tick() {
                    break;
                }
            }
        });
    }
}

pub(crate) use imp::*;
