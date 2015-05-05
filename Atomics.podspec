Pod::Spec.new do |s|
  s.name    = "Atomics"
  s.version = "0.9.0"
  s.summary = "Nifty wrappers for the some of the primitives in OSAtomic package, using Foundation types."

  s.description  = <<-DESC
                   Provides the following classes of atomic wrappers:

                   * `AtomicBoolean`: atomic wrapper for a `BOOL` flag
                   * `AtomicInteger`: atomic wrapper for a `NSInteger` (32 or 64bit, depending on the architecture it's compiled for) with additional counter semantics (_add-and-get_, _get-and-add_)
                   * `AtomicReference`: atomic `NSObject` wrapper
                   DESC

  s.homepage = "https://github.com/timehop/Atomics"
  s.license  = { :type => "MIT", :file => "LICENSE" }

  s.authors          = { "timehop" => "tech@timehop.com", "biasedbit" => "bruno@biasedbit.com" }
  s.social_media_url = "http://twitter.com/timehop"

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
  s.requires_arc = true

  s.source       = { :git => "https://github.com/timehop/Atomics.git", :tag => "0.9.0" }
  s.source_files = "Classes", "Classes/**/*.{h,m}"
end

