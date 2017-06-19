# Tests

No changes can be merged to master without passing the integration tests. What the tests don't cover yet:

* Turning SSH access on->off->on
* Counting instances in the load balancer
* Changing instances in the load balancer
* Anything to do with health checks and how long it takes to replace sick instances.
* Database stuff (which is a todo feature anyway)

# Setting up and running tests.

`cd tests && bundle install && ..`

`./tests/run_tests.sh`

# Example output

<img style='width: 600px' src="example-test-output.png"></img>
