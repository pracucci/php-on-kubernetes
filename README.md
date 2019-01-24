# PHP on Kubernetes

There's no single way to run and operate an application on Kubernetes. As a general purpose and flexible containers orchestrator, different people ends up with different solutions and it's usually a trade-off between features, complexity, performances, which you balance based on your needs.

This repository doesn't aim to provide a one-fits-all solution, but offering options with pros and cons from which you can pick the one that works better to your use case and business.


## Application Logs

1. Log to `php://stdout` or `php://stderr` and enable `catch_workers_output` in php-fpm<br />
   See: [`app-log-php-fpm-via-catch-workers-output/`](app-log-php-fpm-via-catch-workers-output/)

2. Log to unix pipe and tail it on PID 1<br />
   See: [`app-log-php-fpm-via-unix-pipe/`](app-log-php-fpm-via-unix-pipe/)
