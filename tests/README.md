# Tests

No changes can be merged to master without passing the integration tests. What the tests don't cover yet:

* Turning SSH access on->off->on
* Counting instances in the load balancer
* Changing instances in the load balancer
* Anything to do with health checks and how long it takes to replace sick instances.
* Database stuff (which is a todo feature anyway)

# Setting up

1. install AWS CLI - https://aws.amazon.com/cli

2. run `aws configure` for region put `ap-southeast-2`

3. install Bundler - http://bundler.io

4. run `cd tests && bundle install && cd ..`

# Running tests

run `./tests/run_tests.sh`

<img style='width: 400px' src="example-test-output.png"></img>
