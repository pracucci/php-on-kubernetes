# PHP on Kubernetes

There's no single way to run and operate an application on Kubernetes. As a general purpose and flexible containers orchestrator, different people ends up with different solutions and it's usually a trade-off between features, complexity, performances, which you balance based on your needs.

This repository doesn't aim to provide a one-fits-all solution, but offering options with pros and cons from which you can pick the one that works better to your use case and business.


## Application Logs

For a comparison between the following approaches, please see the blog post:<br />
[PHP on Kubernetes: application logging via unix pipe](https://pracucci.com/php-on-kubernetes-application-logging-via-unix-pipe.html)

#### Option 1: log to `php://stdout` or `php://stderr` and enable `catch_workers_output` in php-fpm

![](https://pracucci.com/assets/2019-01-24-php-on-kubernetes-php-fpm-catch-workers-output-b470128db4fbe35b4b68b0980076dec9e95be49c1b3dae929ec5ddb9f92aecb3.png)

- **Pro**: easy.
- **Con**: application logs are wrapped by php-fpm and it makes parsing more complicated.
- **Con**: application logs are truncated to 1024 bytes and splitted into multiple messages. Long logs are not unusual if you use structured logging and you log contextual information on errors (ie. stack trace).
- **Con**: application logs are mixed with php-fpm logs into the same stream.

See a working example at [`app-log-php-fpm-via-catch-workers-output/`](app-log-php-fpm-via-catch-workers-output/).

#### Option 2: log to unix pipe and tail it in a sidecar container<br />

![](https://pracucci.com/assets/2019-01-24-php-on-kubernetes-unix-pipe-148f44c75d4bf6babed6a4effbd2f3f2a542a62563d3288ac5e2fd67c407c85a.png)

See a working example at [`app-log-php-fpm-via-unix-pipe/`](app-log-php-fpm-via-unix-pipe/).

- **Pro**: application logs are not wrapped by php-fpm.
- **Pro**: application logs are not limited by length (no splitting / truncating).
- **Pro**: application logs and php-fpm error logs are not mixed together in the same stream.
